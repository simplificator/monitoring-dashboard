defmodule HttpServer.Controllers.Nodeping do
  use Sugar.Controller

  def get(conn, []) do
    nodeping_list = filter_list(conn.params)
    Kitto.Api.Nodeping.receive_push_and_display_list(nodeping_list)
    raw conn |> resp(200, "Nodeping")
  end

  def filter_list([]), do: []
  def filter_list([head|tail]) do
    if head["event"] in ["down"] do
      [ %{label: head["label"], value: head["event"]} | filter_list(tail) ]
    else
      filter_list(tail)
    end
  end
  def filter_list(head) do
    if head["event"] in ["down"] do
      %{label: head["label"], value: head["event"]}
    else
      []
    end
  end
end
