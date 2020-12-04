defmodule WDcr.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create table(:coins) do
      add :coin_id, :string
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
