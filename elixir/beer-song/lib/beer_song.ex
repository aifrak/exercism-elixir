defmodule BeerSong do
  import String, only: [capitalize: 1]

  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    """
    #{capitalize(bottles(number))} of beer on the wall, #{bottles(number)} of beer.
    #{action(number)}, #{bottles(number - 1)} of beer on the wall.
    """
  end

  defp bottles(number) do
    case number do
      0 -> "no more bottles"
      1 -> "#{number} bottle"
      number when number > 1 -> "#{number} bottles"
      number when number < 1 -> "99 bottles"
    end
  end

  defp action(0), do: "Go to the store and buy some more"
  defp action(1), do: "Take it down and pass it around"
  defp action(number) when number > 1, do: "Take one down and pass it around"

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..00), do: Enum.map_join(range, "\n", &verse/1)
end
