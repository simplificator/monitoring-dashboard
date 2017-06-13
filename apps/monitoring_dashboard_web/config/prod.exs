use Mix.Config

config :monitoring_dashboard_web, MonitoringDashboard.Web.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "aqueous-mountain-74633.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

  new webpack.DefinePlugin({
    'process.env': {
      NODE_ENV: JSON.stringify('production')
    }
  }),
  new webpack.optimize.UglifyJsPlugin()

# Do not print debug messages in production
config :logger, level: :info
