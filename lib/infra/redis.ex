defmodule ArgosWorkers.Redis do
  @pool_size 5
  @behaviour Service.Behaviour.Cache
  def child_spec(_args) do
    # Specs for the Redix connections.
    children =
      for i <- 0..(@pool_size - 1) do
        Supervisor.child_spec({Redix, name: :"redix_#{i}"}, id: {Redix, i})
      end

    # Spec for the supervisor that will supervise the Redix connections.
    %{
      id: RedixSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

  def command(command) do
    Redix.command(:"redix_#{random_index()}", command)
  end

  @impl Service.Behaviour.Cache
  @spec get(any) ::  {:ok, nil} | {:ok, String.t}
  def get(key) do
    reponse = command(["GET", key])
    case reponse do
      {:ok, nil} -> {:ok, nil}
      {:ok, result} when is_binary(result)-> {:ok, result}
      _ -> {:ok, nil}
    end
  end

  @impl Service.Behaviour.Cache
  @spec set(binary, binary) :: nil
  def set(key, data) do
    command(["SET", key, data])
    nil
  end

  defp random_index() do
    rem(System.unique_integer([:positive]), @pool_size)
  end
end
