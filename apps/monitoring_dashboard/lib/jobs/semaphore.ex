defmodule MonitoringDashboard.Job.Semaphore do

  def fetch() do
    semaphore_url()
    |> HTTPoison.get
    |> parse_response
    |> filter
  end

  def semaphore_url() do
    "https://semaphoreci.com/api/v1/projects?auth_token="<>System.get_env("SEMAPHOREAPI")
  end

  def parse_response({ :ok, %{status_code: 200, body: body}}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  def parse_response({ _, %{status_code: _, body: body}}) do
  { :error, Poison.Parser.parse!(body) }
  end

  def filter({ :ok, body }) do
    List.flatten(project(body))
  end

  def filter({ :error, _body }) do
    "Error during connection to new Relic"
  end

  def branch([], _), do: []
  def branch([head|tail], name) do
    if head["result"] in ["failed", "stopped"] and head["branch_name"] in ["master", "production", "develop", "development", "staging"] do
      [ %{label: name<>": "<>head["branch_name"], value: head["result"]} | branch(tail, name) ]
    else
      branch(tail, name)
    end
  end

  def project([]), do: []
  def project([head|tail]), do: [ branch(head["branches"], head["name"]) | project(tail) ]

  def mapping(server) do
    case Map.get(server, "health_status") do
      "red" ->
        %{label: Map.get(server, "name"), value: "Down"}
      _ -> %{label: Map.get(server, "name"), value: "Warning"}
    end
  end
end
