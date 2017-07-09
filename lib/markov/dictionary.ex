defmodule Markov.Dictionary do
  @split_regex ~r/\s+|\.|\?|\!|"|,|;|:|-+/
  @enforce_keys [:text, :markov]

  defstruct [:name, :text, :markov]

  def new(text, opts \\ []) do
    markov = generate_markov(text)

    %__MODULE__{text: text, markov: markov, name: opts[:name]}
  end

  defp generate_markov(text) do
    @split_regex
    |> Regex.split(text, trim: true)
    |> Enum.chunk(2, 1)
    |> Enum.reduce(%{}, &add_to_map/2)
  end

  defp add_to_map([word, next_word], word_map) do
    Map.update word_map, word, [next_word], fn(words) ->
      [next_word | words] |> Enum.uniq
    end
  end
end
