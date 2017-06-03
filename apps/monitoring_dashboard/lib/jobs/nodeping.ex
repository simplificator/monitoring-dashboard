defmodule MonitoringDashboard.Job.Nodeping do

  @api_key System.get_env("NODEPINGAPI")

  def fetch() do
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

end
