defmodule Service.Behaviour.HttpRequest do
  @callback get(String.t, any) :: %{
    :__struct__ => HTTPoison.AsyncResponse | HTTPoison.Response,
    optional(:body) => any,
    optional(:headers) => [any],
    optional(:id) => reference,
    optional(:request) => HTTPoison.Request.t(),
    optional(:request_url) => any,
    optional(:status_code) => integer
  }

  @callback put(String.t, any,any) :: nil
end
