defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, _, output_base) when output_base < 2, do: {:error, "output base must be >= 2"}
  def convert(_, input_base, _) when input_base < 2, do: {:error, "input base must be >= 2"}
  def convert([], _, _), do: {:ok, [0]}

  def convert(digits, input_base, output_base) do
    if Enum.all?(digits, &valid_digit(&1, input_base)) do
      {:ok, do_convert(digits, input_base, output_base)}
    else
      {:error, "all digits must be >= 0 and < input base"}
    end
  end

  defp do_convert(digits, input_base, output_base) do
    digits
    |> to_base10_number(input_base)
    |> from_base10_number(output_base)
  end

  defp valid_digit(digit, base), do: digit >= 0 and digit < base

  defp to_base10_number(digits, base) do
    highest_exponent = length(digits) - 1

    digits
    |> Enum.reduce({0, highest_exponent}, fn digit, {total, exponent} ->
      base10_digit = digit * Integer.pow(base, exponent)

      {total + base10_digit, exponent - 1}
    end)
    |> then(fn {result, _} -> result end)
  end

  defp from_base10_number(0, _), do: [0]

  defp from_base10_number(number, base) do
    number
    |> Stream.unfold(fn
      0 -> nil
      num -> {rem(num, base), div(num, base)}
    end)
    |> Enum.reverse()
  end
end
