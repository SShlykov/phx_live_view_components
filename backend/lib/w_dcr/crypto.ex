defmodule WDcr.Crypto do
  @moduledoc """
  The Crypto context.
  """

  import Ecto.Query, warn: false
  alias WDcr.Repo

  alias WDcr.Crypto.Coinbase

  @doc """
  Returns the list of coins.

  ## Examples

      iex> list_coins()
      [%Coinbase{}, ...]

  """
  def list_coins do
    Repo.all(Coinbase)
  end

  @doc """
  Gets a single coinbase.

  Raises `Ecto.NoResultsError` if the Coinbase does not exist.

  ## Examples

      iex> get_coinbase!(123)
      %Coinbase{}

      iex> get_coinbase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coinbase!(id), do: Repo.get!(Coinbase, id)

  @doc """
  Creates a coinbase.

  ## Examples

      iex> create_coinbase(%{field: value})
      {:ok, %Coinbase{}}

      iex> create_coinbase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coinbase(attrs \\ %{}) do
    %Coinbase{}
    |> Coinbase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coinbase.

  ## Examples

      iex> update_coinbase(coinbase, %{field: new_value})
      {:ok, %Coinbase{}}

      iex> update_coinbase(coinbase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coinbase(%Coinbase{} = coinbase, attrs) do
    coinbase
    |> Coinbase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a coinbase.

  ## Examples

      iex> delete_coinbase(coinbase)
      {:ok, %Coinbase{}}

      iex> delete_coinbase(coinbase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coinbase(%Coinbase{} = coinbase) do
    Repo.delete(coinbase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coinbase changes.

  ## Examples

      iex> change_coinbase(coinbase)
      %Ecto.Changeset{data: %Coinbase{}}

  """
  def change_coinbase(%Coinbase{} = coinbase, attrs \\ %{}) do
    Coinbase.changeset(coinbase, attrs)
  end
end
