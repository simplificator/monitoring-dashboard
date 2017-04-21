use Kitto.Job.DSL

defmodule Kitto.Jobs.Nodeping do

  def new, do: Agent.start(fn -> 0 end)

  def receive_push_and_display_list(nodeping_list) do
    nodeping_list
  end

end

job :nodeping, every: :minute do
  list = Kitto.Jobs.NewRelic.fetch
  broadcast! %{items: list}
end
