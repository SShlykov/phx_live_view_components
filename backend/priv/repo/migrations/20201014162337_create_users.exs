defmodule WDcr.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :is_verified, :boolean, default: false, null: false
      add :first_name, :string
      add :last_name, :string
      add :login_token, :string
      add :password_hash, :string

      timestamps()
    end

  end
end
