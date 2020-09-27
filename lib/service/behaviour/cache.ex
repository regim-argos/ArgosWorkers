defmodule Service.Behaviour.Cache do
  @doc "..."
  @callback get(String.t) :: {:ok, nil} | {:ok, String.t}
  @doc "..."
  @callback set(String.t, String.t) :: nil
end
