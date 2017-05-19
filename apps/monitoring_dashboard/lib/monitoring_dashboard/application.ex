defmodule MonitoringDashboard.Application do
  @moduledoc """
  The MonitoringDashboard Application Service.

  The monitoring_dashboard system business domain lives in this application.

  Exposes API to clients such as the `MonitoringDashboard.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([

      worker(MonitoringDashboard.Polling, [])

    ], strategy: :one_for_one, name: MonitoringDashboard.Supervisor)
  end
end
