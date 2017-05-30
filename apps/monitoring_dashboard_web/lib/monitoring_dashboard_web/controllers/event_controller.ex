defmodule MonitoringDashboard.Web.EventController do
  use MonitoringDashboard.Web, :controller

  def index(conn, _params) do
    MonitoringDashboard.Web.Endpoint.subscribe("semaphore", [])
    MonitoringDashboard.Web.Endpoint.subscribe("new_relic", [])
    MonitoringDashboard.Web.Endpoint.subscribe("github", [])

    conn = conn
    |> put_resp_content_type("text/event-stream")
    |> send_chunked(200)
    {:ok, conn} = receive_broadcast(conn)
    conn
  end

  defp send_event(conn, topic, message) do
    encoded_message = Poison.encode!(message |> Map.merge(%{updated_at: :os.system_time(:seconds)}))
    chunk(conn, "event: #{topic}\ndata: {\"message\": #{encoded_message}}\n\n")
  end

  defp receive_broadcast(conn) do
    receive do
      %Phoenix.Socket.Broadcast{event: event, payload: payload, topic: topic} ->
        send_event(conn, topic, payload)
        receive_broadcast(conn)

      _ ->
        receive_broadcast(conn)
      after
        500000 ->
          conn |> halt
    end
  end
end
