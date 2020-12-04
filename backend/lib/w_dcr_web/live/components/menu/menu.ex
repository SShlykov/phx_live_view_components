defmodule WDcrWeb.Menu do
  @moduledoc false
  use WDcrWeb, :live_component
  alias WDcrWeb.Menu.{Weather, Block}
  alias WDcr.Menus

  def mount(socket) do
    links = Menus.list_pages(:destruct)
    cards = Enum.filter(links, & &1.block == "cards")
    menu  = Enum.filter(links, & &1.block == "menu")

    socket = assign(socket, menu_status: "closed", settings_status: "closed", cards: cards, menu: menu)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="menu <%= @menu_status %>">
      <div class="menu-header">
        <div class="menu_state_title">
          Live view
        </div>
        <button
          phx-click="change_menu_state"
          id="menu_state_controller"
          class="menu_state_controller <%= @menu_status %>"
          phx-target="#menu_state_controller"
        >
          <i class="fal fa-outdent"></i>
        </button>
      </div>
      <div class="menu-body">
        <%= live_component @socket, Block, id: :menu_block1, items: @menu, title: %{title: "PAGES", icon: "fal fa-home"} %>
        <%= live_component @socket, Block, id: :menu_block2, items: @cards, title: %{title: "MORE", icon: "fal fa-plus"} %>
      </div>
      <div class="menu-footer">
        <div class="menu_state_title">
          <%= @user_name %>
        </div>

        <button phx-click="change_settings_status" id="menu_settings_status" class="menu_settings_status <%= @menu_status %>" phx-target="#settings_status">
          <i class="fal fa-cog"></i>
        </button>
      </div>
    </div>
    """
  end

  def handle_event("change_menu_state", _pms, socket) do
    new_state = if socket.assigns.menu_status == "opened", do: "closed", else: "opened"

    {:noreply, assign(socket, menu_status: new_state)}
  end
end
