defmodule Service.Watcher do
  @type t :: %{
    id: integer,
    name: String.t,
    url: String.t,
    status: boolean,
    active: boolean,
    delay: integer,
    last_change: Date,
    notifications: List,
    project_id: integer
  }

  defstruct [
    :name,
    :id,
    :url,
    :status,
    :active,
    :delay,
    :last_change,
    :notifications,
    :project_id
  ]

  @cache Application.get_env(:argos_workers, :cache)
  @repo Application.get_env(:argos_workers, :watcher_repo)
  @http_request Application.get_env(:argos_workers, :http_request)

  def hasNotChange(messageData, dbData) do
    if messageData.delay === dbData.delay && dbData.active === true, do: true, else: false
  end

  @spec getById(integer, integer) :: t
  def getById(id, projectId) do
    cached = @cache.get("cache:#{projectId}:watcher:#{id}:worker")

    case cached do
      {:ok, nil} ->
        watcherdb = @repo.getById(id, projectId)
        @cache.set("cache:#{projectId}:watcher:#{id}:worker", Poison.encode!(watcherdb))
        watcherdb
      {:ok, result} -> Poison.decode!(~s(#{result}), %{keys: :atoms!, as: %Service.Watcher{}})
    end
  end

  @spec measure((() -> any)) :: {float, any}
  def measure(function) do
    {time, result} = function
    |> :timer.tc
    {time/1000, result}
  end

  def verifyStatus(watcher) do
    {latency, response} = Service.Watcher.measure(fn -> @http_request.get(watcher.url) end)
    status = if response.status_code >= 200 && response.status_code < 300, do: true, else: false
    {status, latency}
  end
end
