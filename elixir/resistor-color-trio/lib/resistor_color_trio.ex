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

  @units %{
    ohms: 1,
    kiloohms: 10 ** 3,
    megaohms: 10 ** 6,
    gigaohms: 10 ** 9
  }

  @doc """
  Calculate the resistance value in ohm or kiloohm from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label(colors) do
    resistance = to_resistance(colors)
    resistance |> unit() |> then(&{convert_value(resistance, &1), &1})
  end

  defp to_resistance([c1, c2, c3 | _]), do: Integer.undigits([decode(c1), decode(c2) | zeros(c3)])

  defp decode(color), do: @color_bands[color]

  defp zeros(color), do: List.duplicate(0, @color_bands[color])

  defp unit(resistance) when resistance >= @units.gigaohms, do: :gigaohms
  defp unit(resistance) when resistance >= @units.megaohms, do: :megaohms
  defp unit(resistance) when resistance >= @units.kiloohms, do: :kiloohms
  defp unit(_), do: :ohms

  defp convert_value(resistance, unit), do: resistance |> Kernel./(@units[unit]) |> round()
end
