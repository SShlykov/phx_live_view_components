defmodule WDcrWeb.MenuPageLive.Show do
  use WDcrWeb, :live_view

  alias WDcr.Menus

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:menu_page_title, menu_page_title(socket.assigns.live_action))
     |> assign(:menu_page, Menus.get_page!(id))}
  end

  defp menu_page_title(:show), do: "Show Page"
  defp menu_page_title(:edit), do: "Edit Page"
end
