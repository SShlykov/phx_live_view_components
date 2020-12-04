defmodule WDcrWeb.WebcamController do
  use WDcrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
