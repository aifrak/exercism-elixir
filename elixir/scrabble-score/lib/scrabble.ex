defmodule Scrabble do
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word
    |> String.graphemes()
    |> Stream.map(&String.upcase/1)
    |> Enum.reduce(0, &(letter_score(&1) + &2))
  end

  defp letter_score(char) do
    case char do
      char when char in ~w(A E I O U L N R S T) -> 1
      char when char in ~w(D G) -> 2
      char when char in ~w(B C M P) -> 3
      char when char in ~w(F H V W Y) -> 4
      "K" -> 5
      char when char in ~w(J X) -> 8
      char when char in ~w(Q Z) -> 10
      _ -> 0
    end
  end
end
