defmodule ResistorColorTrio do
  @color_bands %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }

  @kilo 1000

  @doc """
  Calculate the resistance value in ohm or kiloohm from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms}
  def label(colors), do: colors |> to_resistance() |> to_unit()

  defp to_resistance([c1, c2, c3]),
    do: "#{decode(c1)}#{decode(c2)}#{pad_zeros(c3)}" |> String.to_integer()

  defp decode(color), do: @color_bands[color]
  defp pad_zeros(color), do: String.duplicate("0", @color_bands[color])

  defp to_unit(resistance) when resistance >= @kilo, do: {round(resistance / @kilo), :kiloohms}
  defp to_unit(resistance), do: {resistance, :ohms}
end
