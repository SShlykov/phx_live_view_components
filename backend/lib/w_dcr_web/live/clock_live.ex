defmodule WDcrWeb.ClockLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="dt-container">
      <div class="dt-hours">
        <svg width="100%" height="100%" viewBox="0 0 280 280">
          <rect x="0" y="0" fill="none" rx="100%" width="95%" height="95%" style="stroke-dasharray: <%= @time_p.h %>% 1000px"></rect>
        </svg>
        <div class="dt-minutes">
          <svg width="100%" height="100%" viewBox="0 0 280 280">
            <rect x="5" y="5" fill="none" rx="100%" width="95%" height="95%" style="stroke-dasharray: <%= @time_p.m %>% 1000px"></rect>
          </svg>
          <div class="dt-seconds">
            <svg width="100%" height="100%" viewBox="0 0 280 280">
              <rect x="10" y="10" fill="none" rx="100%" width="95%" height="95%" style="stroke-dasharray: <%= @time_p.s %>% 1000px"></rect>
            </svg>
            <h2><%= NimbleStrftime.format(@date, "%H:%M:%S") %></h2>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_date(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
  end

  def handle_event("nav", _path, socket) do
    {:noreply, socket}
  end

  defp put_date(socket) do
    dt = NaiveDateTime.local_now()
    hour = round(dt.hour * (300 / 24))
    minute = round(dt.minute * (300 / 60))
    sec = round(dt.second * (300 / 60))

    assign(socket, date: dt, time_p: %{h: hour, m: minute, s: sec})
  end
end
