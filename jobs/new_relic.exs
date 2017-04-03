use Kitto.Job.DSL

defmodule Kitto.Jobs.NewRelic do
  @api_key [{"X-Api-Key", "e535b99e8df16af131b1b70f99387a492ddf879016d0eef"}]

  def new, do: Agent.start(fn -> 0 end)

  def fetch() do
    new_relic_url()
    |> HTTPoison.get(@api_key)
    |> parse_response
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
    |>Enum.map(fn server -> {Map.get(server, "name"),Map.get(server, "health_status")} end)
  end

  def filter({ :error, body }) do
    "Error during connection to new Relic"
  end
end

{:ok, new_relic} = Kitto.Jobs.NewRelic.new
list = &(&1 |> Kitto.Jobs.Convergence.fetch)

job :new_relic, every: :minute do
   broadcast! %{items: list}
end

