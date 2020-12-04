defmodule WDcr.Crypto.Coinbase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coins" do
    field :coin_id, :string
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(coinbase, attrs) do
    coinbase
    |> cast(attrs, [:coin_id, :name, :description])
    |> validate_required([:coin_id, :name, :description])
  end
end
