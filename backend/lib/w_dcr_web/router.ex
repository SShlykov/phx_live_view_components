defmodule WDcrWeb.Router do
  use WDcrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {WDcrWeb.LayoutView, :root}
    plug WDcr.Plugs.IpPlug
    plug WDcrWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :game do
    plug :put_root_layout, {WDcrWeb.LayoutView, :game}
  end

  pipeline :webcam do
    plug :put_root_layout, {WDcrWeb.LayoutView, :webcam}
  end

  pipeline :simple do
    plug :put_root_layout, {WDcrWeb.LayoutView, :simple}
  end

  scope "/", WDcrWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/users", UserLive.Index
    live "/users/new", UserLive.New
    live "/users/:id/edit", UserLive.Edit
    live "/users/:id", UserLive.Show

    get("/forgot", SessionController, :forgot)
    get("/login", SessionController, :new)
    get("/login/:token/email/:email", SessionController, :create_from_token)
    get("/logout", SessionController, :delete)
    post("/forgot", SessionController, :reset_pass)

    resources(
      "/sessions",
      SessionController,
      only: [:new, :create, :delete],
      singleton: true
    )
  end

  scope "/pages", WDcrWeb do
    pipe_through [:browser]

    live "/", MenuPageLive.Index, :index
    live "/new", MenuPageLive.Index, :new
    live "/:id/edit", MenuPageLive.Index, :edit

    live "/:id", MenuPageLive.Show, :show
    live "/:id/show/edit", MenuPageLive.Show, :edit
  end

  scope "/rooms", WDcrWeb do
    pipe_through [:browser]

    live "/", RoomLive.Index, :index
    live "/new", RoomLive.Index, :new
    live "/:id/edit", RoomLive.Index, :edit

    live "/:id", RoomLive.Show, :show
    live "/:id/show/edit", RoomLive.Show, :edit
  end

  scope "/user_rooms", WDcrWeb do
    pipe_through [:browser]

    live "/", UserRoomLive.Index, :index
    live "/new", UserRoomLive.Index, :new
    live "/:id/edit", UserRoomLive.Index, :edit

    live "/:id", RoomLive.Show, :show
    live "/:id/show/edit", RoomLive.Show, :edit
  end

  scope "/home", WDcrWeb do
    pipe_through [:browser]

    live "/chat", ChatLive
    live "/chat/new", ChatLive, :new
    live "/chat/:id/edit", ChatLive, :edit
    live "/chat/:id", ChatLive, :cncted

    live "/coins", CoinbaseLive.Index, :index
    live "/coins/new", CoinbaseLive.Index, :new
    live "/coins/:id/edit", CoinbaseLive.Index, :edit

    live "/coins/:id", CoinbaseLive.Show, :show
    live "/coins/:id/show/edit", CoinbaseLive.Show, :edit

    live "/", PageLive
    live "/wss_crypto", WssCoinLive
    live "/image_upload", ImageUploadLive
    live "/live_map", MapLive
    live "/galery", GaleryLive
  end

  scope "/home", WDcrWeb do
    pipe_through [:browser, :webcam]

    get "/webcam", WebcamController, :index
    live "/neural_webrtc", WebRtcLive
  end


  scope "/simple", WDcrWeb do
    pipe_through [:browser, :simple]

    live "/clock", ClockLive
    live "/search", SearchLive
    live "/loader", LoaderLive
    live "/auto-scroll", UserLive.AutoScroll
  end

  scope "/games", WDcrWeb do
    pipe_through [:browser, :game]

    live "/snake", SnakeLive
  end
end
