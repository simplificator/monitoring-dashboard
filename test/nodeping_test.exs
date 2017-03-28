defmodule NodepingTest do
  use ExUnit.Case

  import Kitto.Jobs.Nodeping

  test ": nodeping is correctly pulled" do
    {status, body} = fetch()
    assert status == :ok
  end
end
