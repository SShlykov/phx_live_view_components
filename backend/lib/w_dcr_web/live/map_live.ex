defmodule WDcrWeb.MapLive do
  use WDcrWeb, :live_view
  import ShorterMaps

  @countries Countries.all() |> Enum.sort_by(&(&1.name))

  def handle_event("country_selected", %{"country" => code}, socket) do
    country = Countries.filter_by(:alpha2, code) |> List.first()
    {:noreply, assign(socket, :country, country)}
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
        <div class="main" style="flex-direction: column;">
          <div class="liveview-select2"
            phx-hook="SelectCountry"
            phx-update="ignore"
            id="select-country"
          >
            <select name="country">
              <option value="">None</option>
              <%= for c <- @countries do %>
                <option value="<%= c.alpha2 %>" id="<%= c.alpha2 %>">
                  <%= c.name %>
                </option>
              <% end %>
            </select>
          </div>

          <%= if @country do %>
            <iframe src="http://maps.google.com/maps?q=<%= @country.name %>&output=embed"
              width="100%" height="500px" frameborder="0" style="border:0"></iframe>
          <% end %>

        </div>
      </div>
    </div>
    """
  end

  def handle_info({:put, location}, socket) do
    {:noreply, assign(socket, location: location)}
  end

  def mount(_params, ~m{remote_ip, user_name}, socket) do
    {:ok, assign(socket, user_ip: remote_ip, location: nil, user_name: user_name, countries: @countries, country: nil)}
  end
end
