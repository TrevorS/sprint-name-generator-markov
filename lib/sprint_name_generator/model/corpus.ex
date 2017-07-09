defmodule SprintNameGenerator.Model.Corpus do
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]

  alias Markov.Dictionary
  alias SprintNameGenerator.Model.Corpus

  schema "corpora" do
    field :name, :string
    field :text, :string
    field :markov, :map

    timestamps()
  end

  def find_by_name(name) do
    from Corpus, where: [name: ^name]
  end

  def from(%Dictionary{name: name, text: text, markov: markov}) do
    %Corpus{name: name, text: text, markov: markov}
  end
end
