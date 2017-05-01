defmodule Kitto.Api.Nodeping do

  def new, do: Agent.start(fn -> 0 end)

  def receive_push_and_display_list(nodeping_list) do
    post_body = nodeping_list |> Poison.encode!
    post_body = "{\"items\": "<>post_body<>"}"
    {:ok, response} = HTTPoison.post("http://localhost:4000/widgets/nodeping", post_body, %{"Content-Type" => "application/json"})
    IO.puts "response: " <> Kernel.inspect(response)
  end

end
