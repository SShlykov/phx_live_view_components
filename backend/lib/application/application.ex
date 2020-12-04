defmodule WDcr.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      WDcr.Repo,
      WDcrWeb.Telemetry,
      {Phoenix.PubSub, name: WDcr.PubSub},
      WDcrWeb.Endpoint,
      {Coinbase.Client, []},
      {Yolo.Worker, [name: Yolo.Worker]},
    ]

    opts = [strategy: :one_for_one, name: WDcr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    WDcrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
