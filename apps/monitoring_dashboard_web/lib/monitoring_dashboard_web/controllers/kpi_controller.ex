defmodule MonitoringDashboard.Web.KpiController do
  use MonitoringDashboard.Web, :controller

  def grouped_percentage_workdays(conn, _params) do
    IO.puts "Grouped percentage workdays"
    # TODO: Check for api_key
    # TODO: Send data to widget
    conn |> resp(200, "Kpi")
  end

  def grouped_percentage_week(conn, _params) do
    IO.puts "Grouped percentage week"
    # TODO: Check for api_key
    # TODO: Send data to widget
    conn |> resp(200, "Kpi")
  end

  def grouped_percentage_month(conn, _params) do
    IO.puts "Grouped percentage month"
    # TODO: Check for api_key
    # TODO: Send data to widget
    conn |> resp(200, "Kpi")
  end

  def grouped_hours_workdays(conn, _params) do
    IO.puts "Grouped hours workdays"
    # TODO: Check for api_key
    # TODO: Send data to widget
    conn |> resp(200, "Kpi")
  end

  def grouped_hours_week(conn, _params) do
    IO.puts "Grouped hours week"
    # TODO: Check for api_key
    # TODO: Send data to widget
    conn |> resp(200, "Kpi")
  end

  def grouped_hours_month(conn, _params) do
    IO.puts "Grouped hours month"
    # TODO: Check for api_key
    # TODO: Send data to widget
    conn |> resp(200, "Kpi")
  end

  def performance(conn, _params) do
    IO.puts "Performance"
    # TODO: Check for api_key
    # TODO: Send data to widget
    conn |> resp(200, "Kpi")
  end
end
