defmodule ArgosWorkers.Repo do

  use Ecto.Repo,
    otp_app: :argos_workers,
    adapter: Ecto.Adapters.Postgres
end
