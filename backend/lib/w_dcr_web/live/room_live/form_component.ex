defmodule WDcrWeb.RoomLive.FormComponent do
  use WDcrWeb, :live_component
  alias WDcr.{Chat, Accounts}

  @impl true
  def update(%{room: room, user_id: user_id} = assigns, socket) do
    changeset = Chat.change_room(room)
    users =
      Accounts.list_users()
      |> Enum.reject(& &1.id == user_id)
      |> Enum.map(& {"#{Map.get(&1, :first_name)} #{Map.get(&1, :last_name)}", Map.get(&1, :id)})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:users, users)}
  end

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    changeset =
      socket.assigns.room
      |> Chat.change_room(room_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    save_room(socket, socket.assigns.action, room_params)
  end

  defp save_room(socket, :edit, room_params) do
    case Chat.update_room(socket.assigns.room, room_params) do
      {:ok, _room} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp save_room(%{assigns: %{user_id: user_id}} = socket, :new, room_params) do
    case Chat.create_room(room_params, user_id) do
      {:ok, _room} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room created successfully")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end
end
