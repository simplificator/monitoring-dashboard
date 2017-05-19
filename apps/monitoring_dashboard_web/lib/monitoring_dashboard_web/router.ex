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
    get "/dashboards/basic", DashboardController, :show
  end

  scope "/events", MonitoringDashboard.Web do
    # pipe_through(:event_stream)
    get "/", EventController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MonitoringDashboard.Web do
  #   pipe_through :api
  # end
end
