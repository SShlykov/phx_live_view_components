defmodule WDcrWeb.UserRoomLiveTest do
  use WDcrWeb.ConnCase

  import Phoenix.LiveViewTest

  alias WDcr.Chat

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:user_room) do
    {:ok, user_room} = Chat.create_user_room(@create_attrs)
    user_room
  end

  defp create_user_room(_) do
    user_room = fixture(:user_room)
    %{user_room: user_room}
  end

  describe "Index" do
    setup [:create_user_room]

    test "lists all user_rooms", %{conn: conn, user_room: user_room} do
      {:ok, _index_live, html} = live(conn, Routes.user_room_index_path(conn, :index))

      assert html =~ "Listing User rooms"
    end

    test "saves new user_room", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.user_room_index_path(conn, :index))

      assert index_live |> element("a", "New User room") |> render_click() =~
               "New User room"

      assert_patch(index_live, Routes.user_room_index_path(conn, :new))

      assert index_live
             |> form("#user_room-form", user_room: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_room-form", user_room: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_room_index_path(conn, :index))

      assert html =~ "User room created successfully"
    end

    test "updates user_room in listing", %{conn: conn, user_room: user_room} do
      {:ok, index_live, _html} = live(conn, Routes.user_room_index_path(conn, :index))

      assert index_live |> element("#user_room-#{user_room.id} a", "Edit") |> render_click() =~
               "Edit User room"

      assert_patch(index_live, Routes.user_room_index_path(conn, :edit, user_room))

      assert index_live
             |> form("#user_room-form", user_room: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_room-form", user_room: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_room_index_path(conn, :index))

      assert html =~ "User room updated successfully"
    end

    test "deletes user_room in listing", %{conn: conn, user_room: user_room} do
      {:ok, index_live, _html} = live(conn, Routes.user_room_index_path(conn, :index))

      assert index_live |> element("#user_room-#{user_room.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_room-#{user_room.id}")
    end
  end

  describe "Show" do
    setup [:create_user_room]

    test "displays user_room", %{conn: conn, user_room: user_room} do
      {:ok, _show_live, html} = live(conn, Routes.user_room_show_path(conn, :show, user_room))

      assert html =~ "Show User room"
    end

    test "updates user_room within modal", %{conn: conn, user_room: user_room} do
      {:ok, show_live, _html} = live(conn, Routes.user_room_show_path(conn, :show, user_room))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User room"

      assert_patch(show_live, Routes.user_room_show_path(conn, :edit, user_room))

      assert show_live
             |> form("#user_room-form", user_room: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#user_room-form", user_room: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_room_show_path(conn, :show, user_room))

      assert html =~ "User room updated successfully"
    end
  end
end
