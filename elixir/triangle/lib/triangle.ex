defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    cond do
      negative?(a, b, c) -> {:error, "all side lengths must be positive"}
      unequal?(a, b, c) -> {:error, "side lengths violate triangle inequality"}
      equilateral?(a, b, c) -> {:ok, :equilateral}
      isosceles?(a, b, c) -> {:ok, :isosceles}
      true -> {:ok, :scalene}
    end
  end

  defp negative?(a, _, _) when a <= 0, do: true
  defp negative?(_, b, _) when b <= 0, do: true
  defp negative?(_, _, c) when c <= 0, do: true
  defp negative?(_, _, _), do: false

  defp unequal?(a, b, c) when a + b < c, do: true
  defp unequal?(a, b, c) when b + c < a, do: true
  defp unequal?(a, b, c) when a + c < b, do: true
  defp unequal?(_, _, _), do: false

  defp equilateral?(a, a, a), do: true
  defp equilateral?(_, _, _), do: false

  defp isosceles?(a, a, _), do: true
  defp isosceles?(a, _, a), do: true
  defp isosceles?(_, b, b), do: true
  defp isosceles?(_, _, _), do: false
end
