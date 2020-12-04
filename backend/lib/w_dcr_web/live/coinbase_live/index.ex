defmodule WDcrWeb.CoinbaseLive.Index do
  use WDcrWeb, :live_view

  alias WDcr.Crypto
  alias WDcr.Crypto.Coinbase

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :coins, list_coins())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Coinbase")
    |> assign(:coinbase, Crypto.get_coinbase!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Coinbase")
    |> assign(:coinbase, %Coinbase{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Coins")
    |> assign(:coinbase, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    coinbase = Crypto.get_coinbase!(id)
    {:ok, _} = Crypto.delete_coinbase(coinbase)

    {:noreply, assign(socket, :coins, list_coins())}
  end

  defp list_coins do
    Crypto.list_coins()
  end
end
