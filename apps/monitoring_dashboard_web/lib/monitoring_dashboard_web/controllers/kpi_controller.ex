defmodule MonitoringDashboard.Web.KpiController do
  use MonitoringDashboard.Web, :controller
  alias MonitoringDashboard.Web.Endpoint, as: PubSub

  def grouped_percentage_workdays(conn, _params) do
    IO.puts "Grouped percentage workdays"
    if conn.params[:api_key] == System.get_env("KPIAPI") do

      points = get_data(conn.params)
      labels = get_labels(conn.params)
      PubSub.broadcast!("kpi_grouped_percentage_workdays", "status_check", %{points: points, labels: labels})
    end
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

  def get_data(params) do
    series = params[:data][:series]
    Enum.at(series,0)[:data]
    |> get_data( 0)
  end
  def get_data([head|tail], index) do
    [ %{x: index, y: head} | get_data(tail, index+1) ]
  end
  def get_data([] ,_) do
    []
  end

  def get_labels(params) do
    params[:data][:x_axis][:labels]
  end
end
