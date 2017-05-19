defmodule MonitoringDashboard.Web.PageControllerTest do
  use MonitoringDashboard.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
