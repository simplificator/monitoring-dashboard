defmodule MonitoringDashboard.Web.NodepingController do
  use MonitoringDashboard.Web, :controller

  def get(conn, _params) do
    # IO.puts "org result: "<> Kernel.inspect(conn.params)
    # nodeping_list = filter_list(conn.params)
    # IO.puts "controller list: " <> Kernel.inspect(nodeping_list)
    # receive_push_and_display_list(nodeping_list)
    conn |> resp(200, "Nodeping")
  end

  # def filter_list([]), do: []
  # def filter_list([head|tail]) do
  #   if head["event"] in ["down"] do
  #     [ %{label: head["label"], value: head["event"]} | filter_list(tail) ]
  #   else
  #     filter_list(tail)
  #   end
  # end
  # def filter_list(head) do
  #   if head["event"] in ["down"] do
  #     [ %{label: head["label"], value: head["event"]} ]
  #   else
  #     []
  #   end
  # end

  # def receive_push_and_display_list(nodeping_list) do
  #   post_body = nodeping_list |> Poison.encode!
  #   post_body = "{\"items\": "<>post_body<>"}"
  #   {:ok, response} = HTTPoison.post("http://localhost:4000/widgets/nodeping", post_body, %{"Content-Type" => "application/json"})
  #   IO.puts "response: " <> Kernel.inspect(response)
  # end

end
