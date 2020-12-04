defmodule WDcr.CryptoTest do
  use WDcr.DataCase

  alias WDcr.Crypto

  describe "coins" do
    alias WDcr.Crypto.Coinbase

    @valid_attrs %{coin_id: "some coin_id", description: "some description", name: "some name"}
    @update_attrs %{coin_id: "some updated coin_id", description: "some updated description", name: "some updated name"}
    @invalid_attrs %{coin_id: nil, description: nil, name: nil}

    def coinbase_fixture(attrs \\ %{}) do
      {:ok, coinbase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Crypto.create_coinbase()

      coinbase
    end

    test "list_coins/0 returns all coins" do
      coinbase = coinbase_fixture()
      assert Crypto.list_coins() == [coinbase]
    end

    test "get_coinbase!/1 returns the coinbase with given id" do
      coinbase = coinbase_fixture()
      assert Crypto.get_coinbase!(coinbase.id) == coinbase
    end

    test "create_coinbase/1 with valid data creates a coinbase" do
      assert {:ok, %Coinbase{} = coinbase} = Crypto.create_coinbase(@valid_attrs)
      assert coinbase.coin_id == "some coin_id"
      assert coinbase.description == "some description"
      assert coinbase.name == "some name"
    end

    test "create_coinbase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crypto.create_coinbase(@invalid_attrs)
    end

    test "update_coinbase/2 with valid data updates the coinbase" do
      coinbase = coinbase_fixture()
      assert {:ok, %Coinbase{} = coinbase} = Crypto.update_coinbase(coinbase, @update_attrs)
      assert coinbase.coin_id == "some updated coin_id"
      assert coinbase.description == "some updated description"
      assert coinbase.name == "some updated name"
    end

    test "update_coinbase/2 with invalid data returns error changeset" do
      coinbase = coinbase_fixture()
      assert {:error, %Ecto.Changeset{}} = Crypto.update_coinbase(coinbase, @invalid_attrs)
      assert coinbase == Crypto.get_coinbase!(coinbase.id)
    end

    test "delete_coinbase/1 deletes the coinbase" do
      coinbase = coinbase_fixture()
      assert {:ok, %Coinbase{}} = Crypto.delete_coinbase(coinbase)
      assert_raise Ecto.NoResultsError, fn -> Crypto.get_coinbase!(coinbase.id) end
    end

    test "change_coinbase/1 returns a coinbase changeset" do
      coinbase = coinbase_fixture()
      assert %Ecto.Changeset{} = Crypto.change_coinbase(coinbase)
    end
  end
end
