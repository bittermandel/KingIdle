use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kingidle, KingidleWeb.Endpoint,
  http: [port: 4002],
  server: false

# Configure your database
config :kingidle, Kingidle.Repo,
  username: "postgres",
  password: "kingidle",
  database: "kingidle_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
