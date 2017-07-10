defmodule MonitoringDashboard.Web.KpiController do
  use MonitoringDashboard.Web, :controller
  alias MonitoringDashboard.Web.Endpoint, as: PubSub

  def grouped_percentage_workdays(conn, _params) do
    IO.puts "KPI Grouped percentage workdays"
    if conn.params[:api_key] == System.get_env("KPIAPI") do
      points = get_data(conn.params)
      labels = get_labels(conn.params)
      PubSub.broadcast!("grouped_percentage_workdays", "status_check", %{points: points, labels: labels})
    end
    conn |> resp(200, "Kpi")
  end

  def grouped_percentage_week(conn, _params) do
    IO.puts "KPI Grouped percentage week"
    if conn.params["api_key"] == System.get_env("KPIAPI") do
      points = get_data(conn.params)
      labels = get_labels(conn.params)
      PubSub.broadcast!("grouped_percentage_week", "status_check", %{points: points, labels: labels})
    end
    conn |> resp(200, "Kpi")
  end

  def grouped_percentage_month(conn, _params) do
    IO.puts "KPI Grouped percentage month"
    if conn.params["api_key"] == System.get_env("KPIAPI") do
      points = get_data(conn.params)
      labels = get_labels(conn.params)
      PubSub.broadcast!("grouped_percentage_month", "status_check", %{points: points, labels: labels})
    end
    conn |> resp(200, "Kpi")
  end

  def grouped_hours_workdays(conn, _params) do
    IO.puts "KPI Grouped hours workdays"
    if conn.params["api_key"] == System.get_env("KPIAPI") do
      points = get_data(conn.params)
      labels = get_labels(conn.params)
      PubSub.broadcast!("grouped_hours_workdays", "status_check", %{points: points, labels: labels})
    end
    conn |> resp(200, "Kpi")
  end

  def grouped_hours_week(conn, _params) do
    IO.puts "KPI Grouped hours week"
    if conn.params["api_key"] == System.get_env("KPIAPI") do
      points = get_data(conn.params)
      labels = get_labels(conn.params)
      PubSub.broadcast!("grouped_hours_week", "status_check", %{points: points, labels: labels})
    end
    conn |> resp(200, "Kpi")
  end

  def grouped_hours_month(conn, _params) do
    IO.puts "KPI Grouped hours month"
    if conn.params["api_key"] == System.get_env("KPIAPI") do
      points = get_data(conn.params)
      labels = get_labels(conn.params)
      PubSub.broadcast!("grouped_hours_month", "status_check", %{points: points, labels: labels})
    end
    conn |> resp(200, "Kpi")
  end

  def performance(conn, _params) do
    IO.puts "KPI Performance"
    if conn.params["api_key"] == System.get_env("KPIAPI") do
      value = get_value(conn.params)
      IO.puts(Kernel.inspect(value))
      PubSub.broadcast!("performance", "status_check", %{value: value})
    end
    conn |> resp(200, "Kpi")
  end

  def get_data(params) do
    IO.puts(Kernel.inspect(params))
    keys = Map.keys(params)
    first_key = Enum.at(keys,0)
    parsed = Poison.Parser.parse!(first_key)
    series = parsed["data"]["series"]
    Enum.at(series,0)["data"]
    |> get_data( 0)
  end
  def get_data([head|tail], index) do
    [ %{x: index, y: head} | get_data(tail, index+1) ]
  end
  def get_data([] ,_) do
    []
  end

  def get_labels(params) do
    params["data"]["x_axis"]["labels"]
  end

  def get_value(params) do
    IO.puts(Kernel.inspect(params))
    keys = Map.keys(params)
    first_key = Enum.at(keys,0)
    parsed = Poison.Parser.parse!(first_key)
    parsed["data"]["item"]*100
  end
end
