defmodule SprintNameGenerator.Model.Corpus do
  use Ecto.Schema

  schema "corpora" do
    field :name, :string
    field :text, :string
    field :markov, {:map, :string}
  end
end
