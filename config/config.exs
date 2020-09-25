use Mix.Config

config :logger, handle_otp_reports: false

config :argos_workers, ArgosWorkers.Repo,
  database: "test",
  username: "test",
  password: "test",
  hostname: "localhost"

config :postgrex, :json_library, Poison

config :argos_workers, ecto_repos: [ArgosWorkers.Repo]
