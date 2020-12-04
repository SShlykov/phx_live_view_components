defmodule WDcr.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :name, :string
      add :icon, :string
      add :block, :string
      add :link, :string
      add :access, :integer
      add :user_id, :integer
      add :created_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:pages, [:created_by])
  end
end
