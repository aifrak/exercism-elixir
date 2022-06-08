defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    downcased_base = String.downcase(base)
    sorted_base = sort(downcased_base)

    Enum.filter(candidates, fn candidate ->
      downcased_candidate = String.downcase(candidate)

      downcased_candidate != downcased_base &&
        sort(downcased_candidate) == sorted_base
    end)
  end

  defp sort(string) do
    string
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.join()
  end
end
