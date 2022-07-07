defmodule TwelveDays do
  @days [
    Day.new("first", "a Partridge in a Pear Tree"),
    Day.new("second", "two Turtle Doves"),
    Day.new("third", "three French Hens"),
    Day.new("fourth", "four Calling Birds"),
    Day.new("fifth", "five Gold Rings"),
    Day.new("sixth", "six Geese-a-Laying"),
    Day.new("seventh", "seven Swans-a-Swimming"),
    Day.new("eighth", "eight Maids-a-Milking"),
    Day.new("ninth", "nine Ladies Dancing"),
    Day.new("tenth", "ten Lords-a-Leaping"),
    Day.new("eleventh", "eleven Pipers Piping"),
    Day.new("twelfth", "twelve Drummers Drumming")
  ]

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number),
    do: "On the #{day(number).nth} day of Christmas my true love gave to me: #{gifts(number)}."

  defp day(number), do: Enum.at(@days, number - 1)

  defp gifts(number) do
    @days
    |> Enum.take(number)
    |> then(&may_append_and/1)
    |> Enum.reverse()
    |> Enum.map_join(", ", & &1.gift)
  end

  defp may_append_and([h | t]) when length(t) > 0, do: [Day.append_and(h) | t]
  defp may_append_and(days), do: days

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse),
    do: Enum.map_join(starting_verse..ending_verse, "\n", &verse/1)

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing, do: verses(1, length(@days))
end
