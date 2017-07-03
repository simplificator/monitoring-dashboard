defmodule Controllers.KpiControllerTest do
  use ExUnit.Case

  test "get kpi data" do
    params = Poison.Parser.parse!("{
              \"api_key\": \"bpsnBgbCVeM4\",
              \"data\": {
              \"title\": \"Billable hours (this week)\",
              \"series\": [{
              \"data\": [55, 45, 0, 0, 0]
              }],
              \"x_axis\": {
              \"labels\": [\"Mon\", \"Tue\", \"Wed\", \"Thu\", \"Fri\"]
              }
              }
              }")
    result = MonitoringDashboard.Web.KpiController.get_data(params)
    assert result == [%{x: 0, y: 55}, %{x: 1, y: 45}, %{x: 2, y: 0}, %{x: 3, y: 0}, %{x: 4, y: 0}]
  end

  test "get kpi performance item" do
    params = Poison.Parser.parse!("{
                                  \"api_key\": \"bpsnBgbCVeM4\",
                                  \"data\": {
                                  \"title\": \"Performance on Monday\",
                                  \"format\": \"percent\",
                                  \"item\": 0.859375,
                                  \"min\": {
                                  \"value\": 0
                                  },
                                  \"max\": {
                                  \"value\": 1
                                  }
                                  }
                                  }")
    result = MonitoringDashboard.Web.KpiController.get_value(params)
    assert result == 85.9375
  end
  
end