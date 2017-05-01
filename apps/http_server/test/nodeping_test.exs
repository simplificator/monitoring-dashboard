defmodule NodepingTest do
  use ExUnit.Case

  test "filter red" do
    push_result = [%{"event" => "down", "label" => "Medgate Staging", "t" => "HTTP", "tg" => "https://medgate-staging.s.simplificator.com", "token" => "AzaBBzGk7g1s"},
                  %{"event" => "down", "label" => "Medgate Staging", "t" => "HTTP", "tg" => "https://medgate-staging.s.simplificator.com", "token" => "AzaBBzGk7g1s"}]
    result = HttpServer.Controllers.Nodeping.filter_list(push_result)
    assert result == [%{label: "Medgate Staging", value: "down"},%{label: "Medgate Staging", value: "down"}]
  end
end
