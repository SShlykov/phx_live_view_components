defmodule WDcr.Chat.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_rooms" do
    field :user_id, :id
    field :room_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_room, attrs) do
    user_room
    |> cast(attrs, [])
    |> validate_required([])
  end
end
