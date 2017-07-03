defmodule MonitoringDashboard.Cache do
  def start_link do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, fn cache ->
      Map.get(cache, key)
    end)
  end

  def put(key, value) do
    Agent.update(__MODULE__, fn cache ->
      Map.put(cache, key, value))
  end
end
