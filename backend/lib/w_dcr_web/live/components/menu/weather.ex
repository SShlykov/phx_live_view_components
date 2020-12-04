defmodule WDcrWeb.Menu.Weather do
  @moduledoc false

  use WDcrWeb, :live_component

  def mount(socket) do
    # send(self(), {:put, "Saint Peterburg"})
    {:ok, assign(socket, location: nil, weather: "...")}
  end

  def render(assigns) do
    ~L"""
    <form phx-submit="set-location" phx-target="#weather-component" id="weather-component">
      <input name="location" placeholder="Location" value="<%= @location %>"/>
      <br />
      <%= @weather %>
      <br>
      <span class="capt">
        Выберите регион и нажмите Enter
      </span>
    </form>
    """
  end

  def handle_event("set-location", %{"location" => location}, socket) do
    {:noreply, put_location(socket, location)}
  end

  defp put_location(socket, location) do
    try do
      assign(socket, location: location, weather: weather(location))
    rescue
      _e -> assign(socket, location: location, weather: "Не могу получить данные")
    end
  end

  defp weather(local) do
    {:ok, %Tesla.Env{status: 200, body: body}} = Tesla.get("http://wttr.in/#{URI.encode(local)}", query: %{format: 1})

    case String.match?(body, ~r/Unknown/) do
      true -> "wttr.in error"
      false -> IO.iodata_to_binary(body)
    end
  end
end
