use Mix.Config

config :joken, default_signer: System.get_env("SECRET")

config :argos_workers, AMQP_HOST: System.get_env("AMQP_HOST")
config :argos_workers, AMQP_USER: System.get_env("AMQP_USER")
config :argos_workers, AMQP_PASS: System.get_env("AMQP_PASS")
config :argos_workers, API_URL: System.get_env("API_URL")
