defmodule MonitoringDashboard.Job.Nodeping do

  @api_key System.get_env("NODEPINGAPI")

  def fetch() do
    nodeping_url()
    |> HTTPoison.get
    |> parse_response
    |> filter
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
    |> filter_list
  end

  def filter({ :error, _body }) do
    "Error during connection to Nodeping"
  end

  def filter_list([]), do: []
  def filter_list([head|tail]) do
    if head["type"] in ["down","disabled"] do
      [ %{label: head["label"], value: head["type"]} | filter_list(tail) ]
    else
      filter_list(tail)
    end
  end
  def filter_list(head) do
    if head["type"] in ["down","disabled"] do
      [ %{label: head["label"], value: head["type"]} ]
    else
      []
    end
  end

end
