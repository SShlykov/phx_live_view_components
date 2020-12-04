defmodule WDcrWeb.UserLive.Index do
  use WDcrWeb, :live_view
  alias WDcr.Accounts
  alias WDcrWeb.UserView

  def render(assigns), do: UserView.render("index.html", assigns)

  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket), do: WDcr.Accounts.subscribe()

    current_user = Accounts.get_user!(user_id)
    admin_user = WDcrWeb.Auth.is_admin?(current_user)

    {:ok,
     fetch(socket)
     |> assign(current_user: current_user, admin_user: admin_user)}
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: WDcr.Accounts.subscribe()

    {:ok, fetch(socket) |> assign(current_user: nil, admin_user: nil)}
  end

  defp fetch(socket) do
    users = Accounts.list_users()
    assign(socket, users: users, page_title: "Listing Users")
  end

  def handle_event("delete_user", %{"id" => user_id}, socket) do
    Accounts.get_user!(user_id)
    |> Accounts.delete_user()

    {:noreply, socket}
  end

  def handle_info({Accounts, [:user, _], _}, socket) do
    {:noreply, fetch(socket)}
  end
end
