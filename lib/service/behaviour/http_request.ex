defmodule Service.Behaviour.HttpRequest do
  @callback get(String.t) :: %{:status_code => integer()}
end
