defmodule WDcrWeb.CoinbaseLive.FormComponent do
  use WDcrWeb, :live_component

  alias WDcr.Crypto

  @impl true
  def update(%{coinbase: coinbase} = assigns, socket) do
    changeset = Crypto.change_coinbase(coinbase)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"coinbase" => coinbase_params}, socket) do
    changeset =
      socket.assigns.coinbase
      |> Crypto.change_coinbase(coinbase_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"coinbase" => coinbase_params}, socket) do
    save_coinbase(socket, socket.assigns.action, coinbase_params)
  end

  defp save_coinbase(socket, :edit, coinbase_params) do
    case Crypto.update_coinbase(socket.assigns.coinbase, coinbase_params) do
      {:ok, _coinbase} ->
        {:noreply,
         socket
         |> put_flash(:info, "Coinbase updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_coinbase(socket, :new, coinbase_params) do
    case Crypto.create_coinbase(coinbase_params) do
      {:ok, _coinbase} ->
        {:noreply,
         socket
         |> put_flash(:info, "Coinbase created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
