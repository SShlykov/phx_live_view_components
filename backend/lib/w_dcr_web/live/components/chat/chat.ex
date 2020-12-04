defmodule WDcrWeb.Chat do
  @moduledoc false
  use WDcrWeb, :live_component
  alias WDcr.Chat
  alias WDcr.Chat.{Message}

  def mount(socket) do
    {:ok, assign(socket, messages: nil, active_chat: nil, rooms: nil, user_id: nil, user_name: nil, changeset: nil)}
  end

  def update(%{user_id: user_id, active_chat: active_chat, user_name: user_name} = _assigns, socket) do
    rooms = list_rooms(user_id)

    socket =
      case active_chat do
        nil     ->
          assign(socket, rooms: rooms, user_id: user_id, active_chat: active_chat)
        room_id ->
          if connected?(socket), do: Chat.subscribe(room_id)
          messages = Chat.list_messages(room_id: room_id)
          changeset = Chat.change_message(%Message{username: user_name})

          assign(socket, rooms: rooms, user_id: user_id, user_name: user_name, active_chat: active_chat, messages: messages, changeset: changeset)
      end

    {:ok, socket}
  end

  def update(_assigns, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="chat" id="create_room set_room">
      <%= live_component @socket, WDcrWeb.Chat.RoomsBlock, id: :rooms_block, user_id: @user_id, rooms: @rooms, active_chat: @active_chat %>
      <%= live_component @socket, WDcrWeb.Chat.MessagesBlock, id: :room_messages, messages: @messages, active_chat: @active_chat %>
      <%= live_component @socket, WDcrWeb.Chat.MessagesForm,
        id: :room_messages,
        active_chat: @active_chat,
        changeset: @changeset,
        user_id: @user_id,
        user_name: @user_name %>
    </div>
    """
  end

  defp list_rooms(user_id), do: Chat.list_rooms(user_id: user_id)

  def handle_info(_params, socket) do
    {:noreply, socket}
  end

  def handle_event(_, _any, socket) do
    {:noreply, socket}
  end
end
