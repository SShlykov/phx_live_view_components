use Mix.Config

app_hostname = System.get_env("APP_HOSTNAME")
app_secret = System.get_env("SECRET_KEY_BASE")

config :w_dcr, ecto_repos: [WDcr.Repo]

# Configures the endpoint
config :w_dcr, WDcrWeb.Endpoint,
  url: [host: app_hostname || "localhost"],
  secret_key_base: app_secret || "tOMo9IgoTlcWWTg5ZApqSm1VZJ4PYm2CqD8bHYCTePDcMG3OqMWXO6pP8TZvCWX9",
  render_errors: [view: WDcrWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WDcr.PubSub,
  live_view: [signing_salt: "/Hk61Wua"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
