defmodule WDcrWeb.ChatLive do
  use WDcrWeb, :live_view
  import ShorterMaps
  alias WDcr.Chat.Room
  alias WDcr.Chat

  @impl true
  def mount(_session, ~m{remote_ip, user_id, user_name}, socket) do
    Chat.subscribe(user_id: user_id)

    {:ok, assign(socket,
                user_ip: remote_ip,
                location: nil,
                user_name: user_name,
                user_id: user_id,
                active_chat: nil,
                event: nil,
                message: nil,
                chat: nil)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div style="z-index: 1000">
      <%= if @live_action in [:new, :edit] do %>
        <%= live_modal @socket, WDcrWeb.RoomLive.FormComponent,
          id: @room.id || :new,
          title: @page_title,
          action: @live_action,
          user_id: @user_id,
          room: @room,
          return_to: Routes.live_path(@socket, WDcrWeb.ChatLive) %>
      <% end %>

      <div style="display: flex; z-index: 9999">
        <%= live_component @socket, WDcrWeb.Menu,
            id: :main_menu,
            user_ip: @user_ip,
            location: @location,
            user_name: @user_name
        %>

      </div>
      <div class="main-centred" style="z-index: 9998">
        <div>
          <div class="main">
            <%= live_component @socket, WDcrWeb.Chat,
              id: :user_chat,
              user_id: @user_id,
              active_chat: @active_chat,
              user_name: @user_name,
              event: @event,
              message: @message,
              chat: @chat
            %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  @impl true
  def handle_info({_, [:message, :inserted], message}, socket) do
    {:noreply, assign(socket, event: :inserted, message: message)}
  end

  @impl true
  def handle_info({_, [:chat, :inserted], chat}, socket) do
    {:noreply, assign(socket, event: :inserted, chat: chat)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Room")
    |> assign(:room, Chat.get_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Room")
    |> assign(:room, %Room{})
  end

  defp apply_action(socket, :cncted, ~m{id}) do
    socket
    |> assign(:active_chat, id)
  end

  defp apply_action(socket, nil, _params) do
    socket
    |> assign(:page_title, "Listing Rooms")
    |> assign(:room, nil)
  end
end
