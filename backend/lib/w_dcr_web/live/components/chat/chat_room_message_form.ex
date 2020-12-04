defmodule WDcrWeb.Chat.MessagesForm do
  @moduledoc """

  """
  use WDcrWeb, :live_component
  alias WDcr.Chat
  import ShorterMaps

  def mount(socket) do
    {:ok, assign(socket, active_chat: nil, changeset: nil, room_id: nil, user_id: nil, user_name: nil)}
  end

  def update(%{active_chat: active_chat, changeset: changeset, user_id: user_id, user_name: user_name} = _assigns, socket) do
    {:ok, assign(socket, active_chat: active_chat, changeset: changeset, user_id: user_id, user_name: user_name)}
  end

  def render(assigns) do
    ~L"""
    <div class="chat_room_form">
      <%= f = form_for @changeset, "#",
        id: "room-form",
        class: "chat_room_form-form",
        phx_target: @myself,
        phx_change: "validate",
        phx_submit: "save" %>

        <%= text_input f, :message,
          class: if(is_nil(@active_chat), do: "input disabled", else: "input"),
          placeholder: if(is_nil(@active_chat), do: "Чат не выбран", else: "Напишите ваше сообщения"),
          phx_target: "#room-form"
        %>
        <%= error_tag f, :message %>

        <%= submit phx_disable_with: "...",
          class: if(is_nil(@active_chat), do: "disabled"),
          disabled: is_nil(@active_chat)
           do %>
          <i class="fal fa-paper-plane"></i>
        <% end %>
      </form>
    </div>
    """
  end

  def handle_event("validate", ~m(message), socket) do
    {:noreply, assign(socket, message: message)}
  end

  def handle_event("save", ~m(message), %{assigns: %{active_chat: room_id, user_id: user_id, user_name: user_name}} = socket) do
    send_message(socket, room_id, user_id, user_name, message["message"])
  end

  def send_message(socket, room_id, user_id, username, message) do
    {:ok, _any} = Chat.create_message(%{username: username, message: message, room_id: room_id, user_id: user_id})

    {:noreply, assign(socket, message: nil)}
  end
end
