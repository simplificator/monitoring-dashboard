defmodule NodepingTest do
  use ExUnit.Case

  import Kitto.Jobs.Nodeping

  test ": nodeping is correctly pulled" do
    {status, body} = test_response()
    assert status == :ok
  end
end
