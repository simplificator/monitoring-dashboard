use Kitto.Job.DSL

defmodule Kitto.Jobs.Nodeping do

  def new, do: Agent.start(fn -> 0 end)

  def receive_push_and_display_list(nodeping_list) do
    my_job = job :new_relic do
      broadcast! %{items: nodeping_list}
    end
    Kitto.Job.new(my_job)
    end
  end

end
