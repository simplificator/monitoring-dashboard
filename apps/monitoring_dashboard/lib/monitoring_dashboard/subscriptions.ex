defmodule MonitoringDashboard.Subscriptions do
  def start do
    MonitoringDashboard.Web.Endpoint.subscribe("semaphore", [])
    MonitoringDashboard.Web.Endpoint.subscribe("new_relic", [])
    MonitoringDashboard.Web.Endpoint.subscribe("github", [])
    MonitoringDashboard.Web.Endpoint.subscribe("nodeping", [])
  end
end
