defmodule MonitoringDashboard.PollingGithub do
  use GenServer
  require Logger
  alias MonitoringDashboard.Web.Endpoint, as: PubSub
  alias MonitoringDashboard.Job

  @time_interval 10000
  #@time_interval 3600000

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
    #rubyVersionList = Job.Github.fetchRubyVersion
    #railsVersionList = Job.Github.fetchRailsVersion
    #simplyList = Job.Github.fetchSimply

    PubSub.broadcast!("version_test", "status_check", %{ versions: [50,70,30]})
    #PubSub.broadcast!("github_test", "status_check", %{ data: [[83,1,7]]})
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @time_interval)
  end
end
