defmodule WDcr.Repo.Migrations.CreateUserRooms do
  use Ecto.Migration

  def change do
    create table(:user_rooms) do
      add :user_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:user_rooms, [:user_id])
    create index(:user_rooms, [:room_id])
  end
end
