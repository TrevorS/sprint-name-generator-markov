use Mix.Config

config :sprint_name_generator,
  ecto_repos: [SprintNameGenerator.Repo]

import_config "#{Mix.env}.exs"
