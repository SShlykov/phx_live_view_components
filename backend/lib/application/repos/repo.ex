defmodule WDcr.Repo do
  import Helper.Utils, only: [get_config: 2]

  use Ecto.Repo,
    otp_app: :w_dcr,
    adapter: Ecto.Adapters.Postgres

  use Scrivener,
    page_size: get_config(:general, :page_size)
end
