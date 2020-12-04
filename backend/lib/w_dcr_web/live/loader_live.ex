defmodule WDcrWeb.LoaderLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="loader-component">
      <div id="container">
        <div class="divider" aria-hidden="true"></div>
        <p class="loading-text" aria-label="Loading">
          <span class="letter" aria-hidden="true">L</span>
          <span class="letter" aria-hidden="true">o</span>
          <span class="letter" aria-hidden="true">a</span>
          <span class="letter" aria-hidden="true">d</span>
          <span class="letter" aria-hidden="true">i</span>
          <span class="letter" aria-hidden="true">n</span>
          <span class="letter" aria-hidden="true">g</span>
        </p>
      </div>
    </div>

    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
