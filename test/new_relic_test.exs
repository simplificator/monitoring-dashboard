defmodule NewRelicTest do
  use ExUnit.Case

  import Kitto.Jobs.NewRelic

  test ": new relic is correctly pulled" do
    result = fetch()
    assert result == "test"
  end
  
end