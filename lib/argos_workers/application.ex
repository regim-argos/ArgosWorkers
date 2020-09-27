defmodule ArgosWorkers.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts(Application.get_env(:argos_workers, :env))
    children = [
     ArgosWorkers.Redis,
     # ArgosWorkers.Repo,
     # {Worker.Watcher, []},
      # Starts a worker by calling: ArgosWorkers.Worker.start_link(arg)
      # {ArgosWorkers.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArgosWorkers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
