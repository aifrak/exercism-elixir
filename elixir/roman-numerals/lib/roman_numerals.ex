defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    case number do
      number when number >= 1000 -> "M" <> numeral(number - 1000)
      number when number >= 900 -> "CM" <> numeral(number - 900)
      number when number >= 500 -> "D" <> numeral(number - 500)
      number when number >= 400 -> "CD" <> numeral(number - 400)
      number when number >= 100 -> "C" <> numeral(number - 100)
      number when number >= 90 -> "XC" <> numeral(number - 90)
      number when number >= 50 -> "L" <> numeral(number - 50)
      number when number >= 40 -> "XL" <> numeral(number - 40)
      number when number >= 10 -> "X" <> numeral(number - 10)
      number when number >= 9 -> "IX" <> numeral(number - 9)
      number when number >= 5 -> "V" <> numeral(number - 5)
      number when number >= 4 -> "IV" <> numeral(number - 4)
      number when number >= 1 -> "I" <> numeral(number - 1)
      0 -> ""
    end
  end
end
