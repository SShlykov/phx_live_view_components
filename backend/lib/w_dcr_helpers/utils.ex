defmodule Helper.Utils do
  @moduledoc """
  Общие функции
  """

  def get_config(section, key, app \\ Mix.Project.config[:app])

  def get_config(section, :all, app) do
    app
    |> Application.get_env(section)
    |> case do
      nil -> ""
      config -> config
    end
  end

  def get_config(section, key, app) do
    app
    |> Application.get_env(section)
    |> case do
      nil -> ""
      config -> Keyword.get(config, key)
    end
  end
end
