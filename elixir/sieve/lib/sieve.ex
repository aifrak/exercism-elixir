defmodule Sieve do
  @smallest_prime 2
  @offset 2

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) when limit < @smallest_prime, do: []

  def primes_to(limit) do
    limit
    |> do_primes_to(@smallest_prime, init_numbers(limit))
    |> Enum.filter(fn {_, flag} -> flag end)
    |> Enum.map(fn {num, _} -> num end)
  end

  defp init_numbers(limit), do: Enum.map_every(@smallest_prime..limit, 1, &{&1, true})

  defp do_primes_to(limit, start, numbers) when start > limit, do: numbers

  defp do_primes_to(limit, start, numbers),
    do: do_primes_to(limit, next_start(start, numbers), cross_out_every(numbers, start))

  defp next_start(prev_start, numbers),
    do: Enum.find_value(numbers, fn {num, flag} -> if num > prev_start and flag, do: num end)

  defp cross_out_every(numbers, nth) do
    {hd, tl} = Enum.split(numbers, nth - @offset)
    hd ++ Enum.map_every(tl, nth, &cross_out(&1, nth))
  end

  defp cross_out({num, _}, start) when num > start, do: {num, false}
  defp cross_out(elem, _), do: elem
end
