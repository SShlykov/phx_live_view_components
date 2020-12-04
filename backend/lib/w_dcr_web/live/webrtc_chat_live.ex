defmodule WDcrWeb.WebRtcLive do
  use WDcrWeb, :live_view
  import ShorterMaps

  @impl true
  def mount(_session, ~m{remote_ip, user_name}, socket) do
    {:ok, assign(socket, user_ip: remote_ip, location: nil, user_name: user_name)}
  end

  def handle_event("start_stop", _assigns, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="main-centred">
      <div>
        <div class="main">
          <div class="wrtc">
            <canvas id="objects" width="1280" height="720"></canvas>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
