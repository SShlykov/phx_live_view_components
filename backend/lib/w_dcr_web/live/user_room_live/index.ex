defmodule WDcrWeb.UserRoomLive.Index do
  use WDcrWeb, :live_view

  alias WDcr.Chat
  alias WDcr.Chat.UserRoom

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :user_rooms, list_user_rooms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User room")
    |> assign(:user_room, Chat.get_user_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User room")
    |> assign(:user_room, %UserRoom{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User rooms")
    |> assign(:user_room, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_room = Chat.get_user_room!(id)
    {:ok, _} = Chat.delete_user_room(user_room)

    {:noreply, assign(socket, :user_rooms, list_user_rooms())}
  end

  defp list_user_rooms do
    Chat.list_user_rooms()
  end
end
