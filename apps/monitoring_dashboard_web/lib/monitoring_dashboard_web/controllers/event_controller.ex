defmodule MonitoringDashboard.Web.EventController do
  use MonitoringDashboard.Web, :controller

  def index(conn, _params) do
    MonitoringDashboard.Web.Endpoint.subscribe("semaphore", [])

    conn = conn
    |> put_resp_content_type("text/event-stream")
    |> send_chunked(200)
    {:ok, conn} = receive_broadcast(conn)
    conn
  end

  defp send_message(conn, message) do
    chunk(conn, "event: \"message\"\n\ndata: {\"message\": \"#{message}\"}\n\n")
  end

  defp receive_broadcast(conn) do
    receive do
      %Phoenix.Socket.Broadcast{event: event, payload: payload, topic: topic} ->
        send_message(conn, event)
        receive_broadcast(conn)

      _ ->
        receive_broadcast(conn)
      after
        5000 ->
          conn |> halt
    end
  end
end
