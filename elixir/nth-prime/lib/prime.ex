defmodule Prime do
  require Integer

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(1), do: 2
  def nth(2), do: 3
  def nth(count) when count < 1, do: raise(ArgumentError, message: "count must be bigger than 1")

  def nth(count) do
    1
    |> Stream.iterate(&(&1 + 1))
    |> Stream.flat_map(&[6 * &1 - 1, 6 * &1 + 1])
    |> Stream.chunk_while({0, []}, &chunk_prime(&1, &2, count), &after_prime/1)
    |> Enum.at(0)
  end

  defp chunk_prime(number, {current_count, prime_numbers} = acc, count) do
    cond do
      current_count == count - 2 -> {:halt, prime_numbers}
      prime?(number, prime_numbers) -> {:cont, {current_count + 1, [number | prime_numbers]}}
      true -> {:cont, acc}
    end
  end

  defp after_prime(prime_numbers), do: {:cont, List.first(prime_numbers), []}

  defp prime?(number, prime_numbers), do: Enum.all?(prime_numbers, &(rem(number, &1) != 0))
end
