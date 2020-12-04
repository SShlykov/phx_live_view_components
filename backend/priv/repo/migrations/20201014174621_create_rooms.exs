defmodule WDcr.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :description, :string
      add :icon_link, :string

      timestamps()
    end

  end
end
