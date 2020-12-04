defmodule WDcrWeb.WssCoinLive.Coin do
  @moduledoc """

  """
  use WDcrWeb, :live_component
  import ShorterMaps

  def mount(socket) do
    {:ok, assign(socket, coin_name: nil, coin_data: nil, coin: nil)}
  end

  def update(~M{coin_name, coin_data, coin} = _assigns, socket) do
    {:ok, assign(socket, coin_name: coin_name, coin: coin, coin_data: coin_data)}
  end

  def render(assigns) do
    ~L"""
      <div class="coin_component">
        <div class="coin_title">
          <span class="coin_title-title"> <%= @coin_name %> </span>
          <span class="coin_title-description"> <%= @coin.description %> </span>
        </div>
        <div class="coin_component-body">
          <%= if !is_nil(@coin_data) do %>
            <table>
              <thead>
                <tr>
                  <th>Время операции</th>
                  <th>Цена (USD)</th>
                  <th>Объем сделки</th>
                </tr>
              </thead>
              <tbody>
                <%= for c_data <- @coin_data do %>
                  <%= live_component @socket, WDcrWeb.WssCoinLive.Coin.Item,
                    id: :"coin_item:_#{c_data.trade_id}",
                    coin_item: c_data
                  %>
                <% end %>
              </tbody>
            </table>
          <% end %>
        </div>
      </div>
    """
  end
end
