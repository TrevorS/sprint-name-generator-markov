defmodule SprintNameGenerator.Response.Corpora do
  alias SprintNameGenerator.Repo
  alias SprintNameGenerator.Response
  alias SprintNameGenerator.Model.Corpus

  alias Markov.Dictionary

  @fields [:id, :name, :text, :markov]

  def build do
    message =
      Corpus
      |> Repo.all
      |> Enum.map(&Map.take(&1, @fields))
      |> Poison.encode!

    %Response{status_code: :ok, message: message}
  end

  def build(id) when is_binary(id) do
    message =
      id
      |> Corpus.find_by_id
      |> Repo.one
      |> Map.take(@fields)
      |> Poison.encode!

    %Response{status_code: :ok, message: message}
  end

  def build(corpus) when is_map(corpus) do
    message =
      corpus
      |> to_corpus
      |> Repo.insert!
      |> Map.take(@fields)
      |> Poison.encode!

    %Response{status_code: :ok, message: message}
  end

  defp to_corpus(%{"text" => text, "name" => name}) do
    dictionary = Dictionary.new(text, name: name)

    Corpus.from(dictionary)
  end
end
