defmodule Service.Watcher do
  @type t :: %{
    id: integer,
    name: String.t,
    url: String.t,
    status: boolean,
    active: boolean,
    delay: integer,
    lastChange: Date,
    notifications: List,
    projectId: integer
  }

  defstruct [
    :id,
    :name,
    :url,
    :status,
    :active,
    :delay,
    :lastChange,
    :notifications,
    :projectId
  ]

  @http_request Application.get_env(:argos_workers, :http_request)

  def hasNotChange(messageData, dbData) do
    if messageData.delay === dbData.delay && dbData.active === true, do: true, else: false
  end

  def notifyChange(id, projectId, status, lastChange) do
    token = Token.generate_and_sign!(%{"id"=> "ADMIN"})
    @http_request.put("http://localhost:3333/v1/pvt/#{projectId}/changeStatus/#{id}",
    [{
      "Content-Type", "application/json",
    },{
      "Authorization", "Bearer #{token}",
    }], Poison.encode!(%{status: status, lastChange: lastChange}))
  end


  @spec getById(integer, integer) :: t
  def getById(id, projectId) do
    token = Token.generate_and_sign!(%{"id"=> "ADMIN"})
    response = @http_request.get("http://localhost:3333/v1/pvt/#{projectId}/watchers/#{id}",
    [{
      "Content-Type", "application/json",
    },{
      "Authorization", "Bearer #{token}",
    }])
    IO.puts(token)
    Poison.decode!(~s(#{response.body}), %{keys: :atoms, as: %Service.Watcher{}})
  end

  @spec measure((() -> any)) :: {float, any}
  def measure(function) do
    {time, result} = function
    |> :timer.tc
    {time/1000, result}
  end

  def verifyStatus(watcher) do
    {latency, response} = Service.Watcher.measure(fn -> try do
      @http_request.get(watcher.url,[])
    rescue
      _e in HTTPoison.Error -> %{status_code: 500}
      e -> IO.inspect(e)
    end end)
    status = if response.status_code >= 200 && response.status_code < 300, do: true, else: false
    {status, latency}
  end
end
