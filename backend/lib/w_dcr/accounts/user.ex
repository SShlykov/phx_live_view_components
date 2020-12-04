defmodule WDcr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Argon2
  alias WDcr.Menus.Page
  alias WDcr.Chat.{Room, UserRoom, Message}

  @required ~w(email first_name)a
  @optional ~w(last_name login_token)a
  @pwd ~w(password password_confirmation)a

  schema "users" do
    field :email, :string
    field :is_verified, :boolean, default: false
    field :first_name, :string
    field :last_name, :string
    field :login_token, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
    has_many :pages, Page
    has_many :messages, Message
    many_to_many :rooms, Room, join_through: UserRoom, on_replace: :delete
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, attrs \\ %{}) do
    struct
    |> changeset(attrs)
    |> cast(attrs, @pwd)
    |> validate_required(@pwd)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  def token_changeset(struct, attrs \\ %{}) do
    struct
    |> changeset(attrs)
    |> cast(attrs, [:login_token])
    |> hash_login_token()
  end

  def generate_login_token, do: :crypto.strong_rand_bytes(40) |> Base.url_encode64()

  defp hash_login_token(%{valid?: false} = changeset), do: changeset

  defp hash_login_token(%{valid?: true, changes: %{login_token: token}} = changeset) do
    changeset
    |> put_change(:login_token, Argon2.hash_pwd_salt(token))
  end

  defp hash_login_token(%Ecto.Changeset{valid?: true, changes: %{login_token: nil}} = changeset) do
    changeset
    |> put_change(:login_token, nil)
  end


  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(%{valid?: true, changes: %{password: pwd}} = changeset) do
    changeset
    |> put_change(:password_hash, Argon2.hash_pwd_salt(pwd))
  end
end
