defmodule SprintNameGenerator.Response.SprintName do
  alias SprintNameGenerator.Repo
  alias SprintNameGenerator.Response
  alias SprintNameGenerator.Model.Corpus

  def build(id) do
    sprint_name =
      id
      |> Corpus.find_by_id
      |> Repo.one
      |> Markov.generate_sentence

    message = Poison.encode!(%{sprint_name: sprint_name})

    %Response{status_code: :ok, message: message}
  end

  def build do
    sprint_name =
      Corpus.find_random
      |> Repo.one
      |> Markov.generate_sentence

    message = Poison.encode!(%{sprint_name: sprint_name})

    %Response{status_code: :ok, message: message}
  end
end
