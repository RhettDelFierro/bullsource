# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bullsource,
  ecto_repos: [Bullsource.Repo]

# Configures the endpoint
config :bullsource, Bullsource.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Nb/nF7q4idwZ2OTHYQq+48hOsq4Rz8QLrJHzlEq26583fZGa1ElC8eN/UWeoluJf",
  render_errors: [view: Bullsource.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bullsource.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
