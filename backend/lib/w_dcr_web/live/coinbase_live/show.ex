defmodule WDcrWeb.CoinbaseLive.Show do
  use WDcrWeb, :live_view

  alias WDcr.Crypto

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:coinbase, Crypto.get_coinbase!(id))}
  end

  defp page_title(:show), do: "Show Coinbase"
  defp page_title(:edit), do: "Edit Coinbase"
end
