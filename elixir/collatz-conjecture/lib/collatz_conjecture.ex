defmodule CollatzConjecture do
  import Integer

  defguardp is_pos_integer(num) when is_integer(num) and num > 0

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_pos_integer(input), do: Enum.count(steps(input))

  defp steps(input) do
    Stream.unfold(input, fn
      1 -> nil
      n -> {n, step(n)}
    end)
  end

  defp step(n) when is_even(n), do: div(n, 2)
  defp step(n) when is_odd(n), do: 3 * n + 1
end
