defmodule WDcrWeb.UserLive.AutoScroll do
  use Phoenix.LiveView

  alias WDcrWeb.UserLive.Row

  def render(assigns) do
    ~L"""
    <table>
      <thead>
        <td> id </td>
        <td>Имя пользователя</td>
        <td>Телефон</td>
        <td>
          Почта
        </td>
      </thead>
      <tbody id="users"
             phx-update="append"
             phx-hook="InfiniteScroll"
             data-page="<%= @page %>">
        <%= for user <- @users do %>
          <%= live_component @socket, Row, id: "user-#{user.id}", user: user %>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page: 1, per_page: 20)
     |> fetch(), temporary_assigns: [users: []]}
  end

  defp fetch(%{assigns: %{page: page, per_page: per}} = socket) do
    assign(socket, users: WDcr.Accounts.list_users(page, per))
  end

  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    {:noreply, socket |> assign(page: assigns.page + 1) |> fetch()}
  end
end

# Вспомогательные компоненты для перехода

defmodule WDcrWeb.UserLive.Row do
  use Phoenix.LiveComponent

  defmodule Email do
    use Phoenix.LiveComponent

    def mount(socket) do
      {:ok, assign(socket, count: 0)}
    end

    def render(assigns) do
      ~L"""
      <span id="<%= @id %>" phx-click="click" phx-target="#<%= @id %>">
        Email: <%= @email %>
      </span>
      """
    end

    def handle_event("click", _, socket) do
      {:noreply, update(socket, :count, &(&1 + 1))}
    end
  end

  def mount(socket) do
    {:ok, assign(socket, count: 0)}
  end

  def render(assigns) do
    ~L"""
    <tr class="user-row" id="<%= @id %>" phx-click="click" phx-target="#<%= @id %>">
      <td><%= @user.id %></td>
      <td><%= @user.username %></td>
      <td><%= @user.phone_number %></td>
      <td>
        <%= live_component @socket, Email, id: "email-#{@id}", email: @user.email %>
      </td>
    </tr>
    """
  end

  def handle_event("click", _, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end
end
