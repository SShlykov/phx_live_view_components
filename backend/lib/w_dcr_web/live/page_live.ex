defmodule WDcrWeb.PageLive do
  use WDcrWeb, :live_view
  import ShorterMaps

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
        <div class="main">
          <h1>Примеры работы технологии Live View </h1>
          <p style="text-align: center; width: 100vw; heigth: auto;">JS используется исключительно для организации socket связи</p>
          <p style="text-align: center; width: 100vw; heigth: auto;">PS. внешние апи типа погоды и переводов не стабильны (бесплатны) и иногда выдают ошибки</p>
        </div>
      </div>
    </div>
    """
  end

  def handle_info({:put, location}, socket) do
    {:noreply, assign(socket, location: location)}
  end

  def mount(_params, ~m{remote_ip, user_name}, socket) do
    {:ok, assign(socket, user_ip: remote_ip, location: nil, user_name: user_name)}
  end
end
