defmodule HttpServer.Router do
  use Sugar.Router
  plug Sugar.Plugs.HotCodeReload

  if Sugar.Config.get(:sugar, :show_debugger, false) do
    use Plug.Debugger, otp_app: :http_server
  end

  plug Plug.Static, at: "/static", from: :http_server

  # Uncomment the following line for session store
  # plug Plug.Session, store: :ets, key: "sid", secure: true, table: :session

  # Define your routes here
  get "/", HttpServer.Controllers.Main, :index
  get "/nodeping", HttpServer.Controllers.Nodeping, :get
end
