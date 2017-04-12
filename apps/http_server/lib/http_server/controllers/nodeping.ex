defmodule HttpServer.Controllers.Nodeping do
  use Sugar.Controller

  def get(conn, []) do
    nodeping_list = Map.take(conn.params, ["label", "event"])
    Kitto.Jobs.Nodeping.receive_push_and_display_list(nodeping_list)
    raw conn |> resp(200, "Nodeping")
  end
end
