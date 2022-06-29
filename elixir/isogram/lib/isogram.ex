defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence), do: isogram?(sentence, [])
  defp isogram?(<<>>, _), do: true

  defp isogram?(<<char, tail::binary>>, acc) do
    <<char>> = String.downcase(<<char>>)

    cond do
      char in acc -> false
      char in ?a..?z -> isogram?(tail, [char | acc])
      true -> isogram?(tail, acc)
    end
  end
end
