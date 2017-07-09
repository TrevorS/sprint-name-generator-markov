defmodule Markov.Dictionary do
  @split_regex ~r/\s+|\.|\?|,|;|:|-/

  def generate(text) do
    @split_regex
      |> Regex.split(text, trim: true)
      |> Enum.chunk(2, 1)
      |> Enum.reduce(%{}, &add_to_map/2)
  end

  def add_to_map([word, next_word], word_map) do
    Map.update(word_map, word, [next_word], fn(words) ->
      [next_word | words] |> Enum.uniq
    end)
  end
end
