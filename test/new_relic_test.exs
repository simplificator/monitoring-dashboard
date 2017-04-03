defmodule NewRelicTest do
  use ExUnit.Case

  import Kitto.Jobs.NewRelic
  @api_key [{"X-Api-Key", "e535b99e8df16af131b1b70f99387a492ddf879016d0eef"}]

  test ": new relic is correctly pulled" do
    {status, body}  = new_relic_url()
                          |> HTTPoison.get(@api_key)
                          |> parse_response
    assert status == :ok
  end
  
end