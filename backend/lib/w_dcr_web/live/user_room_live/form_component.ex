defmodule WDcrWeb.UserRoomLive.FormComponent do
  use WDcrWeb, :live_component

  alias WDcr.Chat

  @impl true
  def update(%{user_room: user_room} = assigns, socket) do
    changeset = Chat.change_user_room(user_room)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_room" => user_room_params}, socket) do
    changeset =
      socket.assigns.user_room
      |> Chat.change_user_room(user_room_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user_room" => user_room_params}, socket) do
    save_user_room(socket, socket.assigns.action, user_room_params)
  end

  defp save_user_room(socket, :edit, user_room_params) do
    case Chat.update_user_room(socket.assigns.user_room, user_room_params) do
      {:ok, _user_room} ->
        {:noreply,
         socket
         |> put_flash(:info, "User room updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user_room(socket, :new, user_room_params) do
    case Chat.create_user_room(user_room_params) do
      {:ok, _user_room} ->
        {:noreply,
         socket
         |> put_flash(:info, "User room created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
