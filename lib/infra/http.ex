defmodule Http do
  @behaviour Service.Behaviour.HttpRequest

  @impl true
  @spec get(binary, any) :: %{
          :__struct__ => HTTPoison.AsyncResponse | HTTPoison.Response,
          optional(:body) => any,
          optional(:headers) => [any],
          optional(:id) => reference,
          optional(:request) => HTTPoison.Request.t(),
          optional(:request_url) => any,
          optional(:status_code) => integer
        }
  def get(url, headers) do
    response = HTTPoison.get!(url, headers)
    response
  end

  @impl true
  def put(url, headers, data) do
    HTTPoison.put!(url, data, headers)
    nil
  end
end
