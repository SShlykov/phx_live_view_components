defmodule WDcr.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias WDcr.Accounts.User
  alias WDcr.Chat.Room

  schema "messages" do
    field :message, :string
    field :username, :string

    timestamps()
    belongs_to :user, User
    belongs_to :room, Room
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :username, :user_id, :room_id])
    |> validate_required([:message, :username, :user_id, :room_id])
  end
end
