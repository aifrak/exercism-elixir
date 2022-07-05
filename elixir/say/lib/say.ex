defmodule Say do
  @zero_to_nineteen %{
    0 => "zero",
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen"
  }

  @twenty_to_ninety %{
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety"
  }

  @big_numbers %{
    100 => "hundred",
    1000 => "thousand",
    1_000_000 => "million",
    1_000_000_000 => "billion"
  }

  @words @zero_to_nineteen |> Map.merge(@twenty_to_ninety) |> Map.merge(@big_numbers)

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(0), do: {:ok, @words[0]}
  def in_english(number) when number < 0, do: {:error, "number is out of range"}
  def in_english(number) when number >= 1_000_000_000_000, do: {:error, "number is out of range"}

  def in_english(number) do
    translate(number, [])
    |> Enum.reverse()
    |> Enum.join(" ")
    |> String.replace("ty ", "ty-")
    |> then(&{:ok, &1})
  end

  defp translate(0, acc), do: acc

  defp translate(n, acc) when n >= 1_000_000_000,
    do: translate(rest(n, 1_000_000_000), words(n, 1_000_000_000) ++ acc)

  defp translate(n, acc) when n >= 1_000_000,
    do: translate(rest(n, 1_000_000), words(n, 1_000_000) ++ acc)

  defp translate(n, acc) when n >= 1000, do: translate(rest(n, 1000), words(n, 1000) ++ acc)
  defp translate(n, acc) when n >= 100, do: translate(rest(n, 100), words(n, 100) ++ acc)
  defp translate(n, acc) when n >= 20, do: translate(rest(n, 10), words(n, 10) ++ acc)
  defp translate(n, acc), do: translate(0, words(n) ++ acc)

  defp words(n), do: [@words[n]]
  defp words(n, t) when n >= 100, do: [@words[t] | translate(div(n, t), [])]
  defp words(n, t) when n >= 20, do: [@words[div(n, t) * 10]]

  defp rest(number, target), do: number - div(number, target) * target
end
