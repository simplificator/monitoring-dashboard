defmodule MonitoringDashboard.Web.DashboardController do
  use MonitoringDashboard.Web, :controller

  def show(conn, _params) do
    render conn, "show.html"
  end
end
