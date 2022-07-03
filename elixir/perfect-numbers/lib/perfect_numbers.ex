defmodule PerfectNumbers do
  defguardp is_divisor(divisor, dividend) when rem(dividend, divisor) == 0

  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number > 0 do
    number
    |> aliquot_sum()
    |> then(&{:ok, do_classify(&1, number)})
  end

  def classify(_), do: {:error, "Classification is only possible for natural numbers."}

  defp aliquot_sum(number) do
    1..ceil(number / 2)
    |> Stream.filter(&(is_divisor(&1, number) && number != &1))
    |> Enum.sum()
  end

  defp do_classify(sum, number) when sum > number, do: :abundant
  defp do_classify(sum, number) when sum < number, do: :deficient
  defp do_classify(_, _), do: :perfect
end
