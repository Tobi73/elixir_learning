use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vocial, VocialWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :vocial, Vocial.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "vocial_test",
  username: "postgres",
  password: "postgres",
  hostname: "127.0.0.1",
  port: 5433,
  pool: Ecto.Adapters.SQL.Sandbox
