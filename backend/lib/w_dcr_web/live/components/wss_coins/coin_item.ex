defmodule WDcrWeb.WssCoinLive.Coin.Item do
  @moduledoc """

  """
  use WDcrWeb, :live_component
  import ShorterMaps

  def mount(socket) do
    {:ok, assign(socket, coin_item: nil)}
  end

  def update(~M{coin_item} = _assigns, socket) do
    {:ok, assign(socket, coin_item: coin_item)}
  end

  def render(assigns) do
    ~L"""
    <tr class="coin_item <%= @coin_item.side %>">
      <td class="coin_item--time">
        <%= @coin_item.time |> parse_dt %>
      </td>
      <td class="coin_item--price">
        <%= @coin_item.price %>
      </td>
      <td class="coin_item--size">
        <%= @coin_item.size %>
      </td>
    </tr>
    """
  end

  def parse_dt(dt) do
    Timex.parse!(dt, "{ISO:Extended}") |> Timex.shift(hours: 3) |> Timex.format!("%H:%M:%S", :strftime)
  end
end
