defmodule WDcr.Accounts do
  @moduledoc """
  Модуль описывающий бизнес логику бизнес логику аккаунтов
  """
  import Ecto.Query, warn: false
  import Argon2, only: [verify_pass: 2]
  alias WDcr.Accounts.User
  alias WDcr.Repo

  @topic inspect(__MODULE__)

  def subscribe, do: Phoenix.PubSub.subscribe(WDcr.PubSub, @topic)
  def subscribe(user_id), do: Phoenix.PubSub.subscribe(WDcr.PubSub, @topic <> "#{user_id}")


  def list_users(page, per) do
    1..per
    |> Enum.map(fn x ->
      x = x*page
      num = Enum.random(x..1000000000)

      %{
        email: "user#{num}@test",
        id: num,
        inserted_at: ~N[2020-09-28 10:45:40],
        password: nil,
        password_confirmation: nil,
        phone_number: "555-555-5555",
        updated_at: ~N[2020-09-28 10:45:40],
        username: "user#{num}"
      }
    end)
  end


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users, do: Repo.all(User)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(nil), do: nil
  def get_user!(id), do: Repo.get!(User, id)


  def get_username(id) do
    User
    |> select([:first_name, :last_name])
    |> Repo.get(id)
  end
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    |> notify_users([:user, :created])
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    changeset =
      if attrs["password"] == "" do
        &User.changeset/2
      else
        &User.registration_changeset/2
      end

    user
    |> changeset.(attrs)
    |> Repo.update()
    |> notify_users([:user, :updated])
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    user
    |> Repo.delete()
    |> notify_users([:user, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    changeset =
      if attrs["password"] == "" do
        &User.changeset/2
      else
        &User.registration_changeset/2
      end


    changeset.(user, attrs)
  end


  def notify_users({:ok, result}, event) do
    Phoenix.PubSub.broadcast(WDcr.PubSub, @topic, {__MODULE__, event, result})
    Phoenix.PubSub.broadcast(WDcr.PubSub, @topic <> "#{result.id}", {__MODULE__, event, result})

    {:ok, result}
  end
  def notify_users({:error, reason}, _err), do: {:error, reason}

  def authenticate_with_password(email, pwd) do
    user = get_user_by_email(email)

    cond do
      email in WDcr.Banlists.emails() ->
        Process.sleep(500)
        {:error, :unauthorized}

      user && verify_pass(pwd, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Process.sleep(500)
        {:error, :not_found}
    end
  end

  def authenticate_with_token(email, token) do
    user = get_user_by_email(email)

    cond do
      email in WDcr.Banlists.emails() ->
        Process.sleep(500)
        {:error, :unauthorized}

      user && user.login_token && verify_pass(token, user.login_token) ->
        update_user_token(user, nil)
        {:ok, user}

      true ->
        Process.sleep(500)
        {:error, :unauthorized}
    end
  end

  def get_user_by_email(email), do: User |> Repo.get_by(email: email)

  def update_user_token(%User{} = user, token) do
    user
    |> User.token_changeset(%{login_token: token})
    |> Repo.update()
  end
end
