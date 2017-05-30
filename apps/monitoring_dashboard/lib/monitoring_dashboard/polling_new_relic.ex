defmodule MonitoringDashboard.PollingNewRelic do
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
    list = Job.NewRelic.fetch

    PubSub.broadcast!("new_relic", "status_check", %{items: list})
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @time_interval)
  end
end
