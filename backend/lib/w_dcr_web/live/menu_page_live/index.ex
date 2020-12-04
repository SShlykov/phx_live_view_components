defmodule WDcrWeb.MenuPageLive.Index do
  use WDcrWeb, :live_view

  alias WDcr.Menus
  alias WDcr.Menus.Page

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :menu_pages, list_menu_pages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:menu_page_title, "Edit Page")
    |> assign(:menu_page, Menus.get_page!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:menu_page_title, "New Page")
    |> assign(:menu_page, %Page{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:menu_page_title, "Listing Pages")
    |> assign(:menu_page, nil)

  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    menu_page = Menus.get_page!(id)
    {:ok, _} = Menus.delete_page(menu_page)

    {:noreply, assign(socket, :menu_pages, list_menu_pages())}
  end

  defp list_menu_pages do
    Menus.list_pages()
  end
end
