defmodule HttpServer.Controllers.Nodeping do
  use Sugar.Controller

  def get(conn, []) do
    label = conn.params["label"]
    # event = conn.params["event"]

    # label = Map.values(conn.params)
      # |> Enum.map(fn x -> {x["label"], x["event"]} end)

    # label = { conn.params["label"], conn.params["event"] }
    # label = Map.values(conn.params)
    # |> Enum.map(fn x -> x["label"] end)
    Kitto.Jobs.Nodeping.receive_push(label)
    raw conn |> resp(200, "Nodeping")
  end
end
