use Kitto.Job.DSL

defmodule Kitto.Jobs.Nodeping do

  @api_key ["***REMOVED***"]

  def new, do: Agent.start(fn -> 0 end)

  def fetch() do
    nodeping_url()
    |> HTTPoison.get
    |> parse_response
    |> filter
  end

  def test_response() do
    nodeping_url()
    |> HTTPoison.get
    |> parse_response
  end

  def nodeping_url() do
    "https://api.nodeping.com/api/1/results/current?token=#{@api_key}"
  end

  def parse_response({ :ok, %{status_code: 200, body: body}}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  def parse_response({ _, %{status_code: _, body: body}}) do
    { :error, Poison.Parser.parse!(body) }
  end

  def filter({ :ok, body }) do
    Map.values(body)
    |> Enum.map(fn x -> {x["label"], x["type"]} end)
  end

end
