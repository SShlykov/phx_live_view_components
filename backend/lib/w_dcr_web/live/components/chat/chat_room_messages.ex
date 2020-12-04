defmodule WDcrWeb.Chat.MessagesBlock do
  @moduledoc """

  """
  use WDcrWeb, :live_component
  alias WDcr.{Chat, Repo}

  def mount(socket) do
    {:ok, assign(socket, messages: nil, active_chat: nil, room_name: nil, room_users: nil)}
  end

  def update(%{active_chat: active_chat, messages: messages} = _assigns, socket) do
    case active_chat do
      nil   -> {:ok, socket}
      _val  ->
        {room_name, room_users} = Chat.get_prepared_room(active_chat)

        {:ok, assign(socket, active_chat: active_chat, room_name: room_name, room_users: room_users, messages: messages)}
    end
  end

  def render(assigns) do
    ~L"""
    <div class="chat_room_messages">
      <div class="chat_title">
        <%= @room_name %>
          <%= if !is_nil(@room_users) and length(@room_users) > 0 do %>
              <span class="chat_namestring">
                (<%= make_namestring(@room_users) %>)
              </span>
          <% end %>
      </div>
      <div class="chat_room_messages-scroll_wrapper">
        <ul class="chat_room_messages-list" id="chat_room_messages" phx-hook="ChatScroll">
          <%= if is_nil(@active_chat) do %>
            <div class="no-messages_msg">
              С кем бы вы хотели пообщаться?)
              <br>
              Выберите комнату
            </div>
          <% else %>
            <%= if is_nil(@messages) or length(@messages) < 1 do %>
              <div class="no-messages_msg">
                У вас нет ни одного сообщения.
                <br>
                Выберите комнату и напишите ваш первое сообщение!
              </div>
            <% else %>
              <%= for msg <- @messages do %>
                <li><strong> <%= msg.username %> : </strong> <%= msg.message %> </li>
              <% end %>
            <% end %>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def make_namestring(list) do
    list
    |> Enum.reduce(nil, & if(is_nil(&2), do: "#{&1.first_name}", else: "#{&2}, #{&1.first_name}"))
    |> case do
      string when length(string) < 20 -> string
      string -> string |> String.slice(0..17) |> Kernel.<>("...")
    end
  end
end
