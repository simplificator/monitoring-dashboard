defmodule NewRelicTest do
  use ExUnit.Case

  import Kitto.Jobs.NewRelic
  @api_key [{"X-Api-Key", "***REMOVED***"}]

  test ": new relic is correctly pulled" do
    {status, body}  = new_relic_url()
                          |> HTTPoison.get(@api_key)
                          |> parse_response
    assert status == :ok
  end
  
end