defmodule WDcr.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias WDcr.Accounts.User
  alias WDcr.Chat.{UserRoom, Message}

  schema "rooms" do
    field :description, :string
    field :icon_link, :string
    field :name, :string

    timestamps()
    has_many :messages, Message
    many_to_many :users, User, join_through: UserRoom, on_replace: :delete
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description, :icon_link])
    |> validate_required([:name])
  end
end
