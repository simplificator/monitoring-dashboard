defmodule NewRelicTest do
  use ExUnit.Case

  import Kitto.Jobs.NewRelic

  test ": new relic is correctly pulled" do
    {status, body}  = new_relic_url()
                          |> HTTPoison.get([{"X-Api-Key", System.get_env("NEWRELICAPI")}])
                          |> parse_response
    assert status == :ok
  end
  
end