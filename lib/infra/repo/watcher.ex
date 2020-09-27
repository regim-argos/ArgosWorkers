defmodule Repo.Watcher do
  use Ecto.Schema
  @behaviour Service.Behaviour.WatcherRepo

  require Ecto.Query
  schema "watchers" do
    field :name, :string
    field :url, :string
    field :status, :boolean
    field :active, :boolean
    field :delay, :integer
    field :last_change, :utc_datetime
    field :notifications, {:array, :map}
    field :project_id, :integer
  end

  @impl Service.Behaviour.WatcherRepo
  def getById(id,project_id) do
    Repo.Watcher |> Ecto.Query.where(id: ^id, project_id: ^project_id ) |> ArgosWorkers.Repo.one!
  end
end
