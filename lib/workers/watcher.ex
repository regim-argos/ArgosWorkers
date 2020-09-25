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
            host: "localhost",
            username: "guest",
            password: "guest"
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

    body = Poison.decode!(data)
    watcher = Entity.Watcher.getById(body["id"], body["projectId"])
    IO.inspect(watcher)
    Rabbit.sendMessage("delay-exchange", "watcher", data)
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages |> Enum.map(fn e -> e.data end)
    messages
  end

end
