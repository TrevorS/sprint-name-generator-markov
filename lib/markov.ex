defmodule Markov do
  def generate_sentence(dictionary, word_count) do
    sentence =
      Enum.reduce 1..word_count, [], fn(_, words) ->
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
