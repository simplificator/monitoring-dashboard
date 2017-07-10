defmodule MonitoringDashboard.PollingGithub do
  use GenServer
  require Logger
  alias MonitoringDashboard.Web.Endpoint, as: PubSub
  alias MonitoringDashboard.Job

  @time_interval 900000

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

    #rubyVersionList = %{amber: 15, green: 7, red: 79}
    #railsVersionList = %{amber: 0, green: 7, red: 79}
    #simplyList = %{amber: 0, green: 7, red: 79}

    PubSub.broadcast!("ruby", "status_check", %{ versions: [rubyVersionList.green,rubyVersionList.amber,rubyVersionList.red]})
    PubSub.broadcast!("rails", "status_check", %{ versions: [railsVersionList.green,railsVersionList.amber,railsVersionList.red]})
    PubSub.broadcast!("simply", "status_check", %{ versions: [simplyList.green,simplyList.amber,simplyList.red]})
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @time_interval)
  end
end
