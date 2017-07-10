defmodule MonitoringDashboard.Web.Router do
  use MonitoringDashboard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :event_stream do
    plug :accepts, ["text/event-stream"]
  end

  scope "/", MonitoringDashboard.Web do
    pipe_through :browser # Use the default browser stack
    get "/", DashboardController, :show
    get "/dashboards/basic", DashboardController, :show
    get "/nodeping", NodepingController, :get
  end

  scope "/events", MonitoringDashboard.Web do
    # pipe_through(:event_stream)
    get "/", EventController, :index
  end

  scope "/kpi", MonitoringDashboard.Web do
    post "/grouped_percentage_workdays", KpiController, :grouped_percentage_workdays
    post "/grouped_percentage_weeks", KpiController, :grouped_percentage_weeks
    post "/grouped_percentage_months", KpiController, :grouped_percentage_months
    post "/grouped_hours_workdays", KpiController, :grouped_hours_workdays
    post "/grouped_hours_weeks", KpiController, :grouped_hours_weeks
    post "/grouped_hours_months", KpiController, :grouped_hours_months
    post "/performance", KpiController, :performance
  end



  # Other scopes may use custom stacks.
  # scope "/api", MonitoringDashboard.Web do
  #   pipe_through :api
  # end
end
