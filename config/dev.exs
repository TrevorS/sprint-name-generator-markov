use Mix.Config

config :sprint_name_generator, SprintNameGenerator.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sprint_name_generator_dev",
  hostname: "localhost",
  pool_size: 10
