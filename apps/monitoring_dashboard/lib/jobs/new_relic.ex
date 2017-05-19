defmodule MonitoringDashboard.Job.NewRelic do

  def fetch() do
    new_relic_url()
    |> HTTPoison.get([{"X-Api-Key", System.get_env("NEWRELICAPI")}])
    |> parse_response
    |> filter
  end

  def new_relic_url() do
    "https://api.newrelic.com/v2/servers.json"
  end

  def parse_response({ :ok, %{status_code: 200, body: body}}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  def parse_response({ _, %{status_code: _, body: body}}) do
  { :error, Poison.Parser.parse!(body) }
  end

  def filter({ :ok, body }) do
    body["servers"]
    |>Enum.filter_map(fn server -> Map.get(server, "health_status")!== "green" end,fn server -> mapping(server) end)
  end

  def filter({ :error, _body }) do
    "Error during connection to new Relic"
  end

  def mapping(server) do
    case Map.get(server, "health_status") do
      "red" ->
        %{label: Map.get(server, "name"), value: "Down"}
      _ -> %{label: Map.get(server, "name"), value: "Warning"}
    end
  end
end
