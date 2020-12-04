defmodule WDcrWeb.SessionController do
  use WDcrWeb, :controller

  alias WDcr.Accounts

  # Uncommend these after configuring a mailer
  # alias WDcr.Accounts.Email
  # alias WDcr.Mailer

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => "", "password" => ""}}) do
    conn
    |> put_flash(:error, "Please fill in an email address and password")
    |> redirect(to: Routes.session_path(conn, :new))
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_with_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Account not found")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def create_from_token(conn, %{"email" => email, "token" => token}) do
    case Accounts.authenticate_with_token(email, token) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.live_path(conn, WDcrWeb.UserLive.Show, user))

      _ ->
        conn
        |> put_flash(:error, "Invalid login")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def token_login(conn, params) do
    case WDcrWeb.Token.verify(params["token"]) do
      {:ok, %{id: user_id}} ->
        user = Accounts.get_user!(user_id)

        conn
        |> WDcrWeb.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.live_path(conn, WDcrWeb.UserLive.Show, user))

      _ ->
        conn
        |> put_flash(:info, "Please login.")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def forgot(conn, _) do
    render(conn, "forgot.html")
  end

  def reset_pass(conn, %{"credential" => %{"email" => _email}}) do
    # case Accounts.get_cred_by_email(email) do
    #   nil ->
    #     conn
    #     |> put_flash(:error, "Email not found")
    #     |> redirect(to: Routes.session_path(conn, :forgot))

    #   cred ->
    #     token = Accounts.Credential.generate_login_token()
    #     {:ok, cred} = Accounts.update_login_token(cred, token)

    #     link =
    #       WDcrWeb.Endpoint.url() <>
    #         Routes.session_path(conn, :create_from_token, token, cred.email)

    #     if WDcrlication.get_env(:WDcr, :mix_env) in [:dev, :prod] do
    #       user = Accounts.get_user!(cred.user_id)
    #       IO.puts("Configure a transactional mail service to send password reset mail for")
    #       IO.puts("User: #{inspect(user)}")
    #       IO.puts("Link: #{inspect(link)}")
    #       # Function to send password reset link goes here.
    #       # It will depend on your transactional mail service
    #       # and look something like the following:
    #       #
    #       # Email.password_reset(user, link) |> Mailer.deliver()
    #     end

    #     conn
    #     |> put_flash(:info, "A sign-in link has been sent to your email address")
    #     |> redirect(to: Routes.session_path(conn, :forgot))
    # end

    conn
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:success, "Successfully signed out")
    |> redirect(to: "/")
  end
end
