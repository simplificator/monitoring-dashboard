defmodule MonitoringDashboard.PollingKpi do
  use GenServer
  require Logger
  alias MonitoringDashboard.Web.Endpoint, as: PubSub
  alias MonitoringDashboard.Job

  @time_interval 10000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Task.start(fn -> check_status() end)
    schedule_work()
    {:noreply, state}
  end

  defp check_status() do
    PubSub.broadcast!("kpi_test", "status_check", %{ points: [%{x: 0, y: 55},%{x: 1, y: 45},%{x: 2, y: 0},%{x: 3, y: 0},%{x: 4, y: 0}], labels: ["Mon", "Tue", "Wed", "Thu", "Fri"]})
    # PubSub.broadcast!("kpi_test_percentage", "status_check", %{ points: [%{x: 0, y: -0.017857142857142905},%{x: 1, y: -0.017857142857142905},%{x: 2, y: 0},%{x: 3, y: 0},%{x: 4, y: 0}])
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @time_interval)
  end
end
