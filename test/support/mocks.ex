Mox.defmock(ArgosWorkers.Infra.MockRedis, for: Service.Behaviour.Cache)
Mox.defmock(ArgosWorkers.Infra.Repo.MockWatcherRepo, for: Service.Behaviour.WatcherRepo)
Mox.defmock(ArgosWorkers.Infra.MockHttp, for: Service.Behaviour.HttpRequest)
