defmodule MonitoringDashboard.Web.EventController do
  use MonitoringDashboard.Web, :controller

  def index(conn, _params) do
    MonitoringDashboard.Web.Endpoint.subscribe("semaphore", [])
    MonitoringDashboard.Web.Endpoint.subscribe("new_relic", [])
    MonitoringDashboard.Web.Endpoint.subscribe("ruby", [])
    MonitoringDashboard.Web.Endpoint.subscribe("rails", [])
    MonitoringDashboard.Web.Endpoint.subscribe("simply", [])
    MonitoringDashboard.Web.Endpoint.subscribe("nodeping", [])
    MonitoringDashboard.Web.Endpoint.subscribe("grouped_hours_month", [])
    MonitoringDashboard.Web.Endpoint.subscribe("grouped_hours_week", [])
    MonitoringDashboard.Web.Endpoint.subscribe("grouped_hours_workdays", [])
    MonitoringDashboard.Web.Endpoint.subscribe("grouped_percentage_month", [])
    MonitoringDashboard.Web.Endpoint.subscribe("grouped_percentage_weeks", [])
    MonitoringDashboard.Web.Endpoint.subscribe("grouped_percentage_workdays", [])
    MonitoringDashboard.Web.Endpoint.subscribe("performance", [])

    conn = conn
    |> put_resp_content_type("text/event-stream")
    |> send_chunked(200)
    case receive_broadcast(conn) do
      {:ok, conn} -> conn
      result -> result
    end
    #{:ok, conn} = receive_broadcast(conn)
    #conn
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
