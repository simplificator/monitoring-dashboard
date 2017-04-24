defmodule Kitto.Api.Nodeping do

  def new, do: Agent.start(fn -> 0 end)

  def receive_push_and_display_list(nodeping_list) do
    nodeping_list
  end

end
