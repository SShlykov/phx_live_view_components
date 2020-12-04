defmodule WDcrWeb.PageLiveTest do
  use WDcrWeb.ConnCase

  import Phoenix.LiveViewTest

  alias WDcr.Menus

  @create_attrs %{access: 42, icon: "some icon", name: "some name"}
  @update_attrs %{access: 43, icon: "some updated icon", name: "some updated name"}
  @invalid_attrs %{access: nil, icon: nil, name: nil}

  defp fixture(:page) do
    {:ok, page} = Menus.create_page(@create_attrs)
    page
  end

  defp create_page(_) do
    page = fixture(:page)
    %{page: page}
  end

  describe "Index" do
    setup [:create_page]

    test "lists all pages", %{conn: conn, page: page} do
      {:ok, _index_live, html} = live(conn, Routes.page_index_path(conn, :index))

      assert html =~ "Listing Pages"
      assert html =~ page.icon
    end

    test "saves new page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.page_index_path(conn, :index))

      assert index_live |> element("a", "New Page") |> render_click() =~
               "New Page"

      assert_patch(index_live, Routes.page_index_path(conn, :new))

      assert index_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#page-form", page: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.page_index_path(conn, :index))

      assert html =~ "Page created successfully"
      assert html =~ "some icon"
    end

    test "updates page in listing", %{conn: conn, page: page} do
      {:ok, index_live, _html} = live(conn, Routes.page_index_path(conn, :index))

      assert index_live |> element("#page-#{page.id} a", "Edit") |> render_click() =~
               "Edit Page"

      assert_patch(index_live, Routes.page_index_path(conn, :edit, page))

      assert index_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#page-form", page: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.page_index_path(conn, :index))

      assert html =~ "Page updated successfully"
      assert html =~ "some updated icon"
    end

    test "deletes page in listing", %{conn: conn, page: page} do
      {:ok, index_live, _html} = live(conn, Routes.page_index_path(conn, :index))

      assert index_live |> element("#page-#{page.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#page-#{page.id}")
    end
  end

  describe "Show" do
    setup [:create_page]

    test "displays page", %{conn: conn, page: page} do
      {:ok, _show_live, html} = live(conn, Routes.page_show_path(conn, :show, page))

      assert html =~ "Show Page"
      assert html =~ page.icon
    end

    test "updates page within modal", %{conn: conn, page: page} do
      {:ok, show_live, _html} = live(conn, Routes.page_show_path(conn, :show, page))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Page"

      assert_patch(show_live, Routes.page_show_path(conn, :edit, page))

      assert show_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#page-form", page: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.page_show_path(conn, :show, page))

      assert html =~ "Page updated successfully"
      assert html =~ "some updated icon"
    end
  end
end
