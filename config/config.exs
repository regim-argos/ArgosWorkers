use Mix.Config

config :logger, handle_otp_reports: false

config :joken, default_signer: "secret"

config :argos_workers, AMQP_HOST: "localhost"
config :argos_workers, AMQP_USER: "guest"
config :argos_workers, AMQP_PASS: "guest"

import_config "#{Mix.env()}.exs"
