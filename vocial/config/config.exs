# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vocial,
  ecto_repos: [Vocial.Repo]

# Configures the endpoint
config :vocial, VocialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WIxicvsn3+q3ge/kE2fV1AZ0Wty3UK9rl53wzKZmYzgpIhudOFGnPZC2lZlcD4gv",
  render_errors: [view: VocialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Vocial.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
