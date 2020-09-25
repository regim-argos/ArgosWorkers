defmodule Repo.Watcher do
  use Ecto.Schema


  require Ecto.Query
  schema "watchers" do
    field :name, :string
    field :url, :string
    field :status, :boolean
    field :delay, :integer
    field :last_change, :utc_datetime
    field :notifications, {:array, :map}
    field :project_id, :integer
  end

  def getById(id,project_id) do
    Repo.Watcher |> Ecto.Query.where(id: ^id, project_id: ^project_id ) |> ArgosWorkers.Repo.one! |> Map.delete(:__meta__) |>  Map.delete(:__struct__)
  end
end
