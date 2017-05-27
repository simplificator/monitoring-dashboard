defmodule MonitoringDashboard.Web.NodepingController do
  use MonitoringDashboard.Web, :controller

  def get(conn, _params) do
    if conn.params["token"] == System.get_env("NODEPINGTOKEN") do
      nodeping_list = filter_list(conn.params)
      # TODO: Send data to widget
    end
    conn |> resp(200, "Nodeping")
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
      [ %{label: head["label"], value: head["event"]} ]
    else
      []
    end
  end
end
