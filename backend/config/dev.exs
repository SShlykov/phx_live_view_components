use Mix.Config

app_http_port = System.get_env("APP_HTTP_PORT")
_app_https_port = System.get_env("APP_HTTPS_PORT")
ssl_cert_path = System.get_env("SSL_CERT_PATH")
ssl_key_path = System.get_env("SSL_KEY_PATH")
db_host = System.get_env("DB_HOST")
db_name = System.get_env("DB_NAME")
db_pool =
  System.get_env("DB_POOL")
  |> case do
    a when is_binary(a) -> String.to_integer(a)
    _ -> nil
  end
db_port = System.get_env("DB_PORT")
db_username = System.get_env("DB_USERNAME")
db_password = System.get_env("DB_PASSWORD")

config :w_dcr, WDcrWeb.Endpoint,
  http: [port: app_http_port || 2080],
  # https: [
  #   port: app_https_port || 443,
  #   cipher_suite: :strong,
  #   certfile: ssl_cert_path || "priv/cert/cert.pem",
  #   keyfile: ssl_key_path || "priv/cert/key.pem"
  # ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/w_dcr_web/(live|views)/.*(ex)$",
      ~r"lib/w_dcr_web/templates/.*(eex)$"
    ]
  ],
  log: false

config :w_dcr, WDcr.Repo,
  username: db_username || "postgres",
  password: db_password || "postgres",
  database: db_name || "w_dcr_db",
  hostname: db_host || "localhost",
  port: 5432,
  show_sensitive_data_on_connection_error: true,
  pool_size: db_pool || 10,
  log: false

config :w_dcr, Yolo.Worker,
    python: "python",
    detect_script: "python_scripts/detect.py",
    model: {:system, "YOLO_MODEL"}

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
