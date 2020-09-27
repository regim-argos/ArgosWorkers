defmodule Http do
  @behaviour Service.Behaviour.HttpRequest

  @impl true
  def get(url) do
    response = HTTPoison.get!(url)
    %{status_code: response.status_code }
  end
end
