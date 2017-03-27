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
    servers = body["servers"]
    keylist = Enum.map(servers, &{ &1["health_status"], &1["name"]})
    a=[]

    ok = for {"green", n} <- keylist, do: a = a++n
    error = for {"red", n} <- keylist, do: a = a++n

  end

  def filter({ :ok, body }) do
    "Error during connection to new Relic"
  end
end

{:ok, new_relic} = Kitto.Jobs.NewRelic.new
list = &(&1 |> Kitto.Jobs.Convergence.fetch)

job :new_relic, every: :minute do
   broadcast! %{items: list}
end

