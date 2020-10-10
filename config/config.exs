use Mix.Config

config :logger, handle_otp_reports: false

config :joken, default_signer: "secret"

config :argos_workers, AMQP_HOST: "rabbit"
config :argos_workers, AMQP_USER: "guest"
config :argos_workers, AMQP_PASS: "guest"
config :argos_workers, API_URL: "localhost:3333"

import_config "#{Mix.env()}.exs"
