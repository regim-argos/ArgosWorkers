use Mix.Config

config :logger, handle_otp_reports: false

config :argos_workers, ArgosWorkers.Repo,
  database: "argos",
  username: "regim",
  password: "regim2203",
  hostname: "database-1.caocwyg4eada.us-east-1.rds.amazonaws.com"

config :postgrex, :json_library, Poison

config :argos_workers, ecto_repos: [ArgosWorkers.Repo]
