defmodule HttpServer.Controllers.Main do
  use Sugar.Controller

  def index(conn, []) do
    IO.puts Kitto.Api.NewRelic.new_relic_url()
    raw conn |> resp(200, "Hello world")
  end
end
