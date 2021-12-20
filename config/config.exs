# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :v2_order_request,
  ecto_repos: [V2OrderRequest.Repo]

# Configures the endpoint
config :v2_order_request, V2OrderRequestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bnrdo5ipYwvf/Xzxr6DSNtFhvkOOuSLiUc1Qd4N1T0QL9HqavJZN+IbIcLRdCEO+",
  render_errors: [view: V2OrderRequestWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: V2OrderRequest.PubSub,
  live_view: [signing_salt: "gIm7StZD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
