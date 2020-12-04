defmodule WDcr.Menus.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias WDcr.Accounts.User

  schema "pages" do
    field :access, :integer
    field :icon, :string
    field :name, :string
    field :link, :string
    field :block, :string

    timestamps()
    belongs_to :user, User
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:name, :block, :icon, :access, :link])
    |> validate_required([:name, :link, :icon, :access])
  end
end
