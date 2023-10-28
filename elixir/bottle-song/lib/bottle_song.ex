defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    start_bottle..1
    |> Enum.take(take_down)
    |> Enum.map_join("\n\n", &verse/1)
  end

  defp verse(number) do
    count = number |> count() |> String.capitalize()
    bottles = bottles(number)

    previous_count = count(number - 1)
    previous_bottles = bottles(number - 1)

    """
    #{count} green #{bottles} hanging on the wall,
    #{count} green #{bottles} hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be #{previous_count} green #{previous_bottles} hanging on the wall.\
    """
  end

  defp count(0), do: "no"
  defp count(1), do: "one"
  defp count(2), do: "two"
  defp count(3), do: "three"
  defp count(4), do: "four"
  defp count(5), do: "five"
  defp count(6), do: "six"
  defp count(7), do: "seven"
  defp count(8), do: "eight"
  defp count(9), do: "nine"
  defp count(10), do: "ten"

  defp bottles(0), do: "bottles"
  defp bottles(1), do: "bottle"
  defp bottles(count) when count > 1, do: "bottles"
end
