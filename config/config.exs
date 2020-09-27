use Mix.Config

config :logger, handle_otp_reports: false

config :argos_workers, ArgosWorkers.Repo,
  database: "argos",
  username: "postgres",
  password: "docker",
  hostname: "localhost"

config :postgrex, :json_library, Poison

config :argos_workers, ecto_repos: [ArgosWorkers.Repo]

import_config "#{Mix.env()}.exs"
