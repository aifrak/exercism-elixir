defmodule PrimeFactors do
  defguardp is_divisible(dividend, divisor) when rem(dividend, divisor) == 0

  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: do_factors_for(number, 2)

  defp do_factors_for(1, _), do: []

  defp do_factors_for(number, divisor) when is_divisible(number, divisor),
    do: [divisor | do_factors_for(round(number / divisor), divisor)]

  defp do_factors_for(number, divisor), do: do_factors_for(number, divisor + 1)
end
