alias WDcr.{Accounts, Crypto}

[
  %{email: "zeitment@gmail.com",  first_name: "Sergey",     password: "secret",  password_confirmation: "secret"},
  %{email: "test@gmail.com",      first_name: "Test User",  password: "secret",  password_confirmation: "secret"}
] |> Enum.map(&Accounts.create_user/1)

[
  %{block: "cards", icon: "fal fa-clock",           link: "/simple/clock",        name: "Часы"},
  %{block: "cards", icon: "fal fa-snake",           link: "/games/snake",         name: "Змейка"},
  %{block: "cards", icon: "fal fa-users-class",     link: "/simple/auto-scroll",  name: "Авто скроллинг"},
  %{block: "cards", icon: "fal fa-telescope",       link: "/simple/search",       name: "Живой поиск"},
  # %{block: "cards", icon: "fal fa-chart-scatter",   link: "/simple/chat",         name: "Координаты"},
  # %{block: "cards", icon: "fal fa-file-upload",     link: "/simple/chat",         name: "Live Редирект"},
  # %{block: "cards", icon: "fal fa-folder-upload",   link: "/simple/chat",         name: "Файл Uploader"},
  %{block: "cards", icon: "fal fa-spinner",          link: "/simple/loader",       name: "Загрузчик"},
  %{block: "menu",  icon: "fal fa-comments",        link: "/home/chat",           name: "Live Чат"},
  %{block: "menu",  icon: "fab fa-bitcoin",         link: "/home/wss_crypto",     name: "Крипто WSS"},
  %{block: "menu",  icon: "fal fa-camera-home",     link: "/home/neural_webrtc",  name: "Neural Webcam"},
  %{block: "menu",  icon: "fal fa-image-polaroid",  link: "/home/galery",         name: "Галерея"},
  %{block: "menu",  icon: "fal fa-map-marker-alt",  link: "/home/live_map",       name: "Live Карта"},
  %{block: "menu",  icon: "fal fa-image",           link: "/home/image_upload",   name: "Neuro image"}
] |> Enum.map(& Map.put(&1, :access, 1)) |> Enum.map(&WDcr.Menus.create_page/1)


[
  %{name: "BTC-USD", description: "Bitcoin US Dollar Bitfinex rate and access",   coin_id: "BTC-USD"},
  %{name: "ETH-USD", description: "Ethereum US Dollar Bitfinex rate and access",  coin_id: "ETH-USD"},
  %{name: "LTC-USD", description: "Litecoin US Dollar Bitfinex rate and access",  coin_id: "LTC-USD"},
  %{name: "MKR-USD", description: "Maker US Dollar Bitfinex rate and access",     coin_id: "MKR-USD"},
] |> Enum.map(&Crypto.create_coinbase/1)
