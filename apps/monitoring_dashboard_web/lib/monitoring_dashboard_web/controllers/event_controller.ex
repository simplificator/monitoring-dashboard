defmodule MonitoringDashboard.Web.EventController do
  use MonitoringDashboard.Web, :controller

  def index(conn, _params) do
    MonitoringDashboard.Web.Endpoint.subscribe("semaphore", [])
    MonitoringDashboard.Web.Endpoint.subscribe("new_relic", [])
    MonitoringDashboard.Web.Endpoint.subscribe("kpi_test", [])
    MonitoringDashboard.Web.Endpoint.subscribe("version_test", [])
    MonitoringDashboard.Web.Endpoint.subscribe("nodeping", [])
    MonitoringDashboard.Web.Endpoint.subscribe("kpi_grouped_percentage_workdays", [])

    conn = conn
    |> put_resp_content_type("text/event-stream")
    |> send_chunked(200)
    {:ok, conn} = receive_broadcast(conn)
    conn
  end

  defp send_event(conn, topic, message) do
    IO.puts(Kernel.inspect(topic))
    encoded_message = Poison.encode!(message |> Map.merge(%{updated_at: :os.system_time(:seconds)}))
    IO.puts(Kernel.inspect(encoded_message))
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
