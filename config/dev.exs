use Mix.Config

config :argos_workers, cache: ArgosWorkers.Redis
config :argos_workers, watcher_repo: Repo.Watcher
config :argos_workers, http_request: Http
