defmodule Triplet do
  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet), do: Enum.sum(triplet)

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet), do: Enum.product(triplet)

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]), do: a ** 2 + b ** 2 == c ** 2

  @doc """
  Generates a list of pythagorean triplets whose values add up to a given sum.
  """
  @spec generate(non_neg_integer) :: [list(non_neg_integer)]
  def generate(sum) do
    for a <- 3..round(sum / 2),
        b <- 3..round(sum / 2),
        a < b,
        triplet = [a, b, c(a, b)],
        Enum.sum(triplet) == sum and pythagorean?(triplet) do
      triplet
    end
  end

  defp c(a, b), do: (a ** 2 + b ** 2) |> :math.sqrt() |> round()
end
