defmodule Service.Behaviour.WatcherRepo do
  @callback getById(integer, integer) :: %Service.Watcher{}
end
