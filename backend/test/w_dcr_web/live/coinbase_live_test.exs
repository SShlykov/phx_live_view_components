defmodule WDcrWeb.CoinbaseLiveTest do
  use WDcrWeb.ConnCase

  import Phoenix.LiveViewTest

  alias WDcr.Crypto

  @create_attrs %{coin_id: "some coin_id", description: "some description", name: "some name"}
  @update_attrs %{coin_id: "some updated coin_id", description: "some updated description", name: "some updated name"}
  @invalid_attrs %{coin_id: nil, description: nil, name: nil}

  defp fixture(:coinbase) do
    {:ok, coinbase} = Crypto.create_coinbase(@create_attrs)
    coinbase
  end

  defp create_coinbase(_) do
    coinbase = fixture(:coinbase)
    %{coinbase: coinbase}
  end

  describe "Index" do
    setup [:create_coinbase]

    test "lists all coins", %{conn: conn, coinbase: coinbase} do
      {:ok, _index_live, html} = live(conn, Routes.coinbase_index_path(conn, :index))

      assert html =~ "Listing Coins"
      assert html =~ coinbase.coin_id
    end

    test "saves new coinbase", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.coinbase_index_path(conn, :index))

      assert index_live |> element("a", "New Coinbase") |> render_click() =~
               "New Coinbase"

      assert_patch(index_live, Routes.coinbase_index_path(conn, :new))

      assert index_live
             |> form("#coinbase-form", coinbase: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#coinbase-form", coinbase: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.coinbase_index_path(conn, :index))

      assert html =~ "Coinbase created successfully"
      assert html =~ "some coin_id"
    end

    test "updates coinbase in listing", %{conn: conn, coinbase: coinbase} do
      {:ok, index_live, _html} = live(conn, Routes.coinbase_index_path(conn, :index))

      assert index_live |> element("#coinbase-#{coinbase.id} a", "Edit") |> render_click() =~
               "Edit Coinbase"

      assert_patch(index_live, Routes.coinbase_index_path(conn, :edit, coinbase))

      assert index_live
             |> form("#coinbase-form", coinbase: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#coinbase-form", coinbase: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.coinbase_index_path(conn, :index))

      assert html =~ "Coinbase updated successfully"
      assert html =~ "some updated coin_id"
    end

    test "deletes coinbase in listing", %{conn: conn, coinbase: coinbase} do
      {:ok, index_live, _html} = live(conn, Routes.coinbase_index_path(conn, :index))

      assert index_live |> element("#coinbase-#{coinbase.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#coinbase-#{coinbase.id}")
    end
  end

  describe "Show" do
    setup [:create_coinbase]

    test "displays coinbase", %{conn: conn, coinbase: coinbase} do
      {:ok, _show_live, html} = live(conn, Routes.coinbase_show_path(conn, :show, coinbase))

      assert html =~ "Show Coinbase"
      assert html =~ coinbase.coin_id
    end

    test "updates coinbase within modal", %{conn: conn, coinbase: coinbase} do
      {:ok, show_live, _html} = live(conn, Routes.coinbase_show_path(conn, :show, coinbase))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Coinbase"

      assert_patch(show_live, Routes.coinbase_show_path(conn, :edit, coinbase))

      assert show_live
             |> form("#coinbase-form", coinbase: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#coinbase-form", coinbase: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.coinbase_show_path(conn, :show, coinbase))

      assert html =~ "Coinbase updated successfully"
      assert html =~ "some updated coin_id"
    end
  end
end
