defmodule WDcrWeb.Menu.Block do
  @moduledoc false

  use WDcrWeb, :live_component

  def mount(socket) do
    socket = assign(socket, menu_item_status: "closed")
    {:ok, socket}
  end

  def update(%{title: %{title: title} = ttl, id: id, items: items} = _assigns, socket) do
    state =
      title
      |> case do
        "PAGES" -> "opened"
        _       -> "closed"
      end
    {:ok, assign(socket, menu_item_status: state, id: id, title: ttl, items: items)}
  end

  def render(assigns) do
    ~L"""
    <ul class='menu_wrapper <%= @menu_item_status %>'>
      <li
        class="menu_wrapper-title"
        id="menu_wrapper-title-<%= @id %>"
        phx-target="#menu_wrapper-title-<%= @id %>"
        phx-click="menu_wrapper-title">

        <i class="<%= @title[:icon] %>"></i>
        <span><%= @title[:title] %></span>
        <i class="fal fa-chevron-down chevron chevron-<%= @menu_item_status %>"></i>

      </li>
      <%= for item <- @items do %>
        <a class='menu-link<%= if item.link == "#", do: " unavaliable" %>' href="<%= item.link %>">
          <i class="<%= item[:icon] %>"></i> <span><%= item.name %></span>
        </a>
      <% end %>
    </ul>
    """
  end

  def handle_event("menu_wrapper-title", _pms, socket) do
    new = if socket.assigns.menu_item_status == "opened", do: "closed", else: "opened"

    {:noreply, assign(socket, menu_item_status: new)}
  end
end
