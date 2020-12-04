defmodule WDcrStorage do
  @moduledoc """
  GenServed module for live view aaplication
  """
  use GenServer

  @impl true
  def init(stack), do: {:ok, stack}

  def start_link(default) when is_list(default), do: GenServer.start_link(__MODULE__, default)
end
