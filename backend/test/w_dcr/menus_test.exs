defmodule WDcr.MenusTest do
  use WDcr.DataCase

  alias WDcr.Menus

  describe "pages" do
    alias WDcr.Menus.Page

    @valid_attrs %{access: 42, icon: "some icon", name: "some name"}
    @update_attrs %{access: 43, icon: "some updated icon", name: "some updated name"}
    @invalid_attrs %{access: nil, icon: nil, name: nil}

    def page_fixture(attrs \\ %{}) do
      {:ok, page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menus.create_page()

      page
    end

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Menus.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Menus.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = Menus.create_page(@valid_attrs)
      assert page.access == 42
      assert page.icon == "some icon"
      assert page.name == "some name"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menus.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, %Page{} = page} = Menus.update_page(page, @update_attrs)
      assert page.access == 43
      assert page.icon == "some updated icon"
      assert page.name == "some updated name"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Menus.update_page(page, @invalid_attrs)
      assert page == Menus.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Menus.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Menus.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Menus.change_page(page)
    end
  end
end
