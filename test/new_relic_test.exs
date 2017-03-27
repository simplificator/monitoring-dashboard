defmodule NewRelicTest do
  use ExUnit.Case

  import Kitto.Jobs.NewRelic

  test ": new relic is correctly pulled" do
    {status, body}  = fetch()
    assert status == :ok
  end
  
end