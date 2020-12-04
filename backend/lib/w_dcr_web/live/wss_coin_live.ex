defmodule WDcrWeb.WssCoinLive do
  @moduledoc false
  use WDcrWeb, :live_view
  import ShorterMaps

  def handle_info({_, [:coinbase, :new], coin_op}, socket) do
    id = coin_op.product_id
    coin_list = socket.assigns.coin_list
    coin_list = update_in(coin_list[id][:data], & if(is_nil(&1), do: [coin_op], else: [coin_op | &1]) |> check_coin_list_len() )
    {:noreply, assign(socket, coin_list: coin_list)}
  end

  def mount(_params, ~m{remote_ip, user_name}, socket) do
    Coinbase.Client.subscribe()
    coin_list =  WDcr.Crypto.list_coins() |> prepare_coins()

    {:ok, assign(socket, user_ip: remote_ip, location: nil, user_name: user_name, coin_list: coin_list)}
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
        <div class="main">
          <%= for coin_name <- Map.keys(@coin_list) do %>
            <%= live_component @socket, WDcrWeb.WssCoinLive.Coin,
              id: :"coin:_#{coin_name}",
              coin_name: coin_name,
              coin: @coin_list[coin_name],
              coin_data: @coin_list[coin_name].data%>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp check_coin_list_len(list) do
    list |> Enum.slice(0..30)
  end

  defp prepare_coins(coins) do
    coins
    |> Enum.map(& Map.delete(&1, :__struct__) |> Map.delete(:__meta__))
    |> Enum.group_by(& &1.coin_id)
    |> Enum.map(fn {key, val} -> %{key => List.first(val) |> Map.put(:data, nil)} end)
    |> Enum.reduce(%{}, fn map, acc -> Map.merge(acc, map) end)
  end
end
