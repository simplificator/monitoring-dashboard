defmodule Kitto.Api.Nodeping do

  def new, do: Agent.start(fn -> 0 end)

  def receive_push_and_display_list(nodeping_list) do
    IO.puts Kernel.inspect(nodeping_list)
    post_body = nodeping_list |> Poison.encode!
    IO.puts Kernel.inspect(post_body)
    {:ok, response} = HTTPoison.post("http://localhost:4000/widgets/nodeping", post_body, %{"Content-Type" => "application/json"})
    IO.puts Kernel.inspect(response)
  end

end
