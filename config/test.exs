use Mix.Config

config :argos_workers, cache:  ArgosWorkers.Infra.MockRedis
config :argos_workers, watcher_repo: ArgosWorkers.Infra.Repo.MockWatcherRepo
config :argos_workers, http_request: ArgosWorkers.Infra.MockHttp
