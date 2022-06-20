defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    factors
    |> Stream.filter(&(&1 > 0))
    |> Stream.flat_map(&multiples(limit, &1))
    |> Stream.uniq()
    |> Enum.sum()
  end

  defp multiples(limit, factor) do
    factor
    |> Stream.iterate(&(&1 + factor))
    |> Enum.take_while(&(&1 < limit))
  end
end
