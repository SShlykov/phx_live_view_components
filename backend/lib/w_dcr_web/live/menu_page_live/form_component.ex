defmodule WDcrWeb.MenuPageLive.FormComponent do
  use WDcrWeb, :live_component

  alias WDcr.Menus

  @impl true
  def update(%{menu_page: menu_page} = assigns, socket) do
    changeset = Menus.change_page(menu_page)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"page" => menu_page_params}, socket) do
    changeset =
      socket.assigns.menu_page
      |> Menus.change_page(menu_page_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"page" => menu_page_params}, socket) do
    save_menu_page(socket, socket.assigns.action, menu_page_params)
  end

  defp save_menu_page(socket, :edit, menu_page_params) do
    case Menus.update_page(socket.assigns.menu_page, menu_page_params) do
      {:ok, _menu_page} ->
        {:noreply,
         socket
         |> put_flash(:info, "Page updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_menu_page(socket, :new, menu_page_params) do
    case Menus.create_page(menu_page_params) do
      {:ok, _menu_page} ->
        {:noreply,
         socket
         |> put_flash(:info, "Page created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
