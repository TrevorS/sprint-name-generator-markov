defmodule SprintNameGenerator.Mixfile do
  use Mix.Project

  def project do
    [app: :sprint_name_generator,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      extra_applications: [:logger, :ecto, :postgrex, :cowboy, :plug],
      mod: {SprintNameGenerator.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:postgrex, "~> 0.13"},
      {:ecto, "~> 2.1"},
      {:poison, "~> 3.1"},
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"}
    ]
  end
end
