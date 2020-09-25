defmodule Entity.Watcher do
  def getById(id, projectId) do
    cache = ArgosWorkers.Redix.command(["GET", "cache:#{projectId}:watcher:#{id}"])
    case cache do
      {:ok, nil} ->
        watcherdb = Repo.Watcher.getById(id, projectId)
        test= ArgosWorkers.Redix.command(["SET", "cache:#{projectId}:watcher:#{id}", Poison.encode!(watcherdb)])
        IO.inspect(test)
        watcherdb
      {:ok, result} -> Poison.decode!(result)
    end
  end
end
