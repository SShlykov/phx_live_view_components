defmodule WDcrWeb.PageController do
  use WDcrWeb, :controller

  def index(conn, _params) do
    if is_nil(Map.get(conn, :current_user)) do
      render(conn, "index.html")
    else
      redirect(conn, to: Routes.live_path(conn, WDcrWeb.PageLive))
    end
  end
end
