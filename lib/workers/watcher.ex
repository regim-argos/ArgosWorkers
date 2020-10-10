defmodule Worker.Watcher do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Rabbit.getQueue("watcher")
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwayRabbitMQ.Producer,
          queue: "watcher",
          qos: [
            prefetch_count: 50,
          ],
          connection: [
            host: Application.get_env(:argos_workers, :AMQP_HOST),
            username: Application.get_env(:argos_workers, :AMQP_USER),
            password: Application.get_env(:argos_workers, :AMQP_PASS)
          ],
        },
        concurrency: 1,
      ],
      processors: [
        default: [
          concurrency: 100,
        ]
      ],
      batchers: [
        default: [
          batch_size: 30,
          concurrency: 80,
          batch_timeout: 2000
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{data: data} = message, _) do
    messageData = Poison.decode!(~s(#{data}), %{keys: :atoms, as: %Service.Watcher{}})
    watcher = Service.Watcher.getById(messageData.id, messageData.projectId)
    if Service.Watcher.hasNotChange(messageData, watcher) do
      Rabbit.sendMessage("delay-exchange", "watcher", data, watcher.delay * 1000 )
      try do
        {status, latency} = Service.Watcher.verifyStatus(watcher)
        IO.puts("status: #{status}")
        IO.puts("watcher.status: #{watcher.status}")
        if status !== watcher.status do
          IO.puts("entrou aqui")
          Service.Watcher.notifyChange(messageData.id, messageData.projectId, status, DateTime.to_iso8601(DateTime.utc_now()))
        end
        IO.inspect(status)
        IO.inspect(latency/1000)
      rescue
        _e in HTTPoison.Error -> %{status_code: 500}
        e -> IO.inspect(e)
      end
    end
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages |> Enum.map(fn e -> e.data end)
    messages
  end

end
