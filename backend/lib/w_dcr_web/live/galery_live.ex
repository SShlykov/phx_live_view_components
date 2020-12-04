defmodule WDcrWeb.GaleryLive do
  use WDcrWeb, :live_view
  import ShorterMaps
  alias Wdcr.Gallery

  def mount(_params, ~m{remote_ip, user_name}, socket) do
    {:ok, assign(socket, user_ip: remote_ip, location: nil, user_name: user_name, current_id: Gallery.first_id(), slideshow: :stopped)}
  end

  def render(assigns) do
    ~L"""
    <div style="display: flex;">
      <%= live_component @socket, WDcrWeb.Menu,
            id: :main_menu,
            user_ip: @user_ip,
            location: @location,
            user_name: @user_name %>

    </div>
    <div class="main-centred">
      <div>
        <div class="main" style="flex-direction: column;">
          <center>
            <%= for id <- Gallery.image_ids() do %>
              <img src="<%= Gallery.thumb_url(id) %>"
              class="<%= thumb_css_class(id, @current_id) %>">
            <% end %>
          </center>
            <label>Counter: <%= @current_id %></label>
            <div class="buttons-controllers">
              <button phx-click="next">следующая</button>
              <button phx-click="prev">предыдущая</button>
              <%= if @slideshow == :stopped do %>
                <button phx-click="play_slideshow">авто</button>
              <% else %>
                <button phx-click="stop_slideshow">отключить</button>
              <% end %>
            </div>
            <div style="display: flex; justify-content: center; align-items: center;">
              <img width="500" src="<%= Gallery.large_url(@current_id)  %>">
            </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("play_slideshow", _, socket) do
    {:ok, ref} = :timer.send_interval(1_000, self(), :slideshow_next)
    {:noreply, assign(socket, :slideshow, ref)}
  end

  def handle_info(:slideshow_next, socket) do
    {:noreply, assign_next_id(socket)}
  end

  def handle_event("stop_slideshow", _, socket) do
    :timer.cancel(socket.assigns.slideshow)
    {:noreply, assign(socket, :slideshow, :stopped)}
  end

  def handle_event("prev", _, socket) do
    {:noreply, assign_prev_id(socket)}
  end

  def handle_event("next", _, socket) do
    {:noreply, assign_next_id(socket)}
  end

  def assign_prev_id(socket) do
    assign(socket, :current_id,
      Gallery.prev_image_id(socket.assigns.current_id))
  end

  def assign_next_id(socket) do
    assign(socket, :current_id,
      Gallery.next_image_id(socket.assigns.current_id))
  end

  defp thumb_css_class(thumb_id, current_id) do
    if thumb_id == current_id do
      "thumb-selected"
    else
      "thumb-unselected"
    end
  end
end
