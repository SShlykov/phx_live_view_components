defmodule WDcrWeb.UserRoomLive.Show do
  use WDcrWeb, :live_view

  alias WDcr.Chat

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_room, Chat.get_user_room!(id))}
  end

  defp page_title(:show), do: "Show User room"
  defp page_title(:edit), do: "Edit User room"
end
