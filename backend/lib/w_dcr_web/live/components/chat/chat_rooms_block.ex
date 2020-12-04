defmodule WDcrWeb.Chat.RoomsBlock do
  @moduledoc """

  """
  use WDcrWeb, :live_component

  def render(assigns) do
    ~L"""
      <div class="chat_room_block">
        <div class="chat_room_block-title">
          <h6>Чат комнаты</h6>

          <%= live_patch to: Routes.chat_path(@socket, :new, user_id: @user_id), class: "chat_room_block-add_new" do %>
            <i class="fal fa-plus"></i>
          <% end %>
          <button  phx-click="create_room" phx-target="#create_room">
          </button>
          <button class="chat_room_block-find_existing" phx-click="">
            <i class="fal fa-search"></i>
          </button>
        </div>

        <div class="rooms_list-wrapper">
          <ul class="rooms_list">
            <%= for room <- @rooms do %>
              <li class='rooms_list-item <%=  if @active_chat == "#{room.id}", do: "active" %>'>
                <%= live_patch to: Routes.chat_path(@socket, :cncted, room) do %>
                  <%= room.name %>
                <% end %>
              </li>
            <% end %>
          </ul>
        </div>
      </div>
    """
  end
end
