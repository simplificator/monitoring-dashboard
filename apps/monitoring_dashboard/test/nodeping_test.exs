defmodule NodepingTest do
  use ExUnit.Case

  import Kitto.Api.Nodeping

  test ": nodeping is correctly pulled" do
    {status, _} = test_response()
    assert status == :ok
  end
end
