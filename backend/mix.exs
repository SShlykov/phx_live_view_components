defmodule WDcr.MixProject do
  use Mix.Project

  def project do
    [
      app: :w_dcr,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {WDcr.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :os_mon,
        :websockex
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:faker, "~> 0.13"},
      {:floki, ">= 0.27.0", only: :test},
      # Феникс и его html шаблонизатор
      {:phoenix, "~> 1.5"},
      {:phoenix_html, "~> 2.14"},
      # Live view + мониторинг системы
      {:phoenix_live_view, "~> 0.15.0"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 0.5.1"},
      # Переводы и работа с текстом
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      # сервер эликсира
      {:plug_cowboy, "~> 2.0"},
      # ОРМ
      {:phoenix_ecto, "~> 4.1"},
      # Адаптеры для ОРМ
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      # компиляция в бинарные файлы
      {:distillery, "~> 2.1"},
      # вспомогательный инструмент для MAP
      {:shorter_maps, "~> 2.0"},
      # вспомогательный http клиент
      {:tesla, "~> 1.3.0"},
      # парсер для времени
      {:nimble_strftime, "~> 0.1.0"},
      # Пагинатор для ОРМ
      {:scrivener_ecto, "~> 2.0.0"},
      # Пароли и кэширование
      {:comeonin, "~> 5.3"},
      {:argon2_elixir, "~> 2.3"},
      # Вебсокеты
      {:websockex, "~> 0.4.2"},
      {:morphix, "~> 0.8.0"},
      {:timex, "~> 3.5"},
      {:uuid, "~> 1.1"},
      {:countries, "~> 1.6"},
      {:ecto_psql_extras, "~> 0.2"},
    ]
  end

  defp aliases do
    [
      "frontend.setup": ["cmd npm install --prefix assets"],
      "db.setup": ["ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/seed.exs"],
      setup: ["deps.get", "ecto.migrate", "frontend.setup"]
    ]
  end
end
