defmodule Coinbase.Client do
  use WebSockex

  @topic "coins"
  @url "wss://ws-feed.pro.coinbase.com"

  def start_link(_opts) do
    {:ok, pid} = WebSockex.start_link(@url, __MODULE__, :no_state)
    subscribe(pid, WDcr.Crypto.list_coins() |> Enum.map(& Map.get(&1, :coin_id)))
    {:ok, pid}
  end

  def handle_connect(_conn, state) do
    IO.puts "Connected!"
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    IO.puts "disconnected"
    {:ok, state}
  end

  def subscribtion_frame(products) do

    subscription_msg = %{
      type: "subscribe",
      product_ids: products,
      channels: ["matches"]
    } |> Jason.encode!()

      {:text, subscription_msg}
  end

  defp subscribe(pid, products) do
    WebSockex.send_frame pid, subscribtion_frame(products)
  end

  def handle_frame({:text, msg}, state) do
    handle_msg(Jason.decode!(msg), state)
  end
  def handle_msg(%{"type" => "match"} = trade, state) do
    {:ok, _result} = notify_users(trade)
    {:ok, state}
  end

  def handle_msg(_, state), do: {:ok, state}

  def subscribe(), do: Phoenix.PubSub.subscribe(WDcr.PubSub, "#{@topic}")

  def notify_users(trade) do
    Phoenix.PubSub.broadcast(WDcr.PubSub, @topic, {__MODULE__, [:coinbase, :new] , Morphix.atomorphiform!(trade)})
    {:ok, trade}
  end
end
