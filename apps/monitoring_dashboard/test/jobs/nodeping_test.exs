defmodule NodepingTest do
  use ExUnit.Case

  import MonitoringDashboard.Job.Nodeping

  test "filter green" do
    api_result = {:ok,%{}}
    result = filter(api_result)
    assert result == []

  end

  test "filter red" do
    api_result = {:ok,
                     %{"2011121513258RKB2-K8MZ0T7B" => %{"_id" => "2011121513258RKB2-K8MZ0T7B-1483542378579",
                         "label" => "Medgate: bpm Status PMS-Service:ok ",
                         "t" => 1483542378579, "type" => "disabled"}}}
    result = filter(api_result)
    assert result == [%{label: "Medgate: bpm Status PMS-Service:ok ", value: "disabled"}]
  end
end
