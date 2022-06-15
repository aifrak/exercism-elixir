defmodule Pangram do
  @initial_counts Map.new(?a..?z, &{<<&1>>, 0})

  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    sentence
    |> String.splitter("", trim: true)
    |> Enum.frequencies_by(&String.downcase/1)
    |> then(&Map.merge(@initial_counts, &1))
    |> Enum.all?(fn {_, count} -> count > 0 end)
  end
end
