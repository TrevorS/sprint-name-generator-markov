defmodule Markov do
  @defaults %{word_count: 5, starting_words: []}

  def generate_sentence(dictionary, opts \\ []) do
    word_count = Keyword.get(opts, :word_count, @defaults.word_count)
    starting_words = Keyword.get(opts, :starting_words, @defaults.starting_words)

    sentence =
      Enum.reduce 1..word_count, starting_words, fn(_, words) ->
        word =
          words
          |> previous_word
          |> next_word(dictionary)

        [word | words]
      end

    Enum.reverse(sentence)
  end

  defp previous_word([]), do: nil
  defp previous_word([word|_]), do: word

  defp next_word(nil, %{markov: markov}),
    do: markov |> Map.keys |> Enum.random

  defp next_word(current_word, %{markov: markov}),
    do: markov |> Map.get(current_word) |> Enum.random
end
