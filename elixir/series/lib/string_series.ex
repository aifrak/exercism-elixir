defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) do
    cond do
      size > 0 and size <= String.length(s) -> slice(s, size)
      true -> []
    end
  end

  defp slice(s, size) do
    s
    |> String.length()
    |> then(&(0..(&1 - size)))
    |> Enum.map(&String.slice(s, &1..(&1 + size - 1)))
  end
end
