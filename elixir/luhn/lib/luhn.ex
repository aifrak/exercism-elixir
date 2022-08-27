defmodule Luhn do
  require Integer

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    if valid_input?(number) do
      number
      |> String.replace(" ", "")
      |> String.graphemes()
      |> Enum.reverse()
      |> Enum.map_reduce(0, &{String.to_integer(&1) |> may_double(&2), &2 + 1})
      |> elem(0)
      |> Enum.sum()
      |> valid_sum?()
    else
      false
    end
  end

  defp valid_input?(number),
    do: String.length(number) > 1 and String.match?(number, ~r/^(\d+ ?)+$/)

  defp valid_sum?(sum) when rem(sum, 10) == 0, do: true
  defp valid_sum?(_), do: false

  defp may_double(digit, index) when Integer.is_odd(index), do: normalize(digit * 2)
  defp may_double(digit, _), do: digit

  defp normalize(double) when double > 9, do: double - 9
  defp normalize(double), do: double
end
