defmodule MonitoringDashboard.PollingGithub do
  use GenServer
  require Logger
  alias MonitoringDashboard.Web.Endpoint, as: PubSub
  alias MonitoringDashboard.Job

  @time_interval 1000

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
    rubyVersionList = Job.Github.fetchRubyVersion
    railsVersionList = Job.Github.fetchRailsVersion
    simplyList = Job.Github.fetchSimply

    #TODO Broadcast lists to Github widgets
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @time_interval)
  end
end
