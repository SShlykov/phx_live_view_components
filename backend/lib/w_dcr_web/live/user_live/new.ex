defmodule WDcrWeb.UserLive.New do
  use Phoenix.LiveView
  alias WDcr.Accounts
  alias Accounts.User
  alias WDcrWeb.{UserView}
  alias WDcrWeb.Router.Helpers, as: Routes

  def render(assigns), do: UserView.render("new.html", assigns)

  def mount(_params, _session, socket) do
    cset = Accounts.change_user(%User{})
    {:ok, assign(socket, changeset: cset)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    cset =
      %User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: cset)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        token = Accounts.User.generate_login_token()
        {:ok, user} = Accounts.update_user_token(user, token)

        {:noreply,
         socket
         |> put_flash(:info, "user created")
         |> redirect(
           to:
             Routes.session_path(
               socket,
               :create_from_token,
               token,
               user.email
             )
         )}

      {:error, %Ecto.Changeset{} = cset} ->
        {:noreply, assign(socket, changeset: cset)}
    end
  end
end
