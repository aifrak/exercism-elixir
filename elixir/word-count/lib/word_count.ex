defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    ~r/\d|\p{L}+(?:['-]?\p{L}+)*/u
    |> Regex.scan(sentence)
    |> Stream.flat_map(& &1)
    |> Enum.frequencies_by(&String.downcase/1)
  end
end
