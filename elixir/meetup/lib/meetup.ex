defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekdays %{
    1 => :monday,
    2 => :tuesday,
    3 => :wednesday,
    4 => :thursday,
    5 => :friday,
    6 => :saturday,
    7 => :sunday
  }

  @teenths 13..19

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    Date.new!(year, month, 1)
    |> Date.days_in_month()
    |> then(&Enum.map(1..&1, fn day -> Date.new!(year, month, day) end))
    |> Enum.filter(fn date -> match_weekday?(date, weekday) end)
    |> find_by_schedule(schedule)
  end

  defp match_weekday?(date, weekday) do
    date
    |> Date.day_of_week()
    |> then(&(@weekdays[&1] == weekday))
  end

  defp find_by_schedule(dates, :first), do: List.first(dates)
  defp find_by_schedule(dates, :second), do: Enum.at(dates, 1)
  defp find_by_schedule(dates, :third), do: Enum.at(dates, 2)
  defp find_by_schedule(dates, :fourth), do: Enum.at(dates, 3)
  defp find_by_schedule(dates, :last), do: List.last(dates)
  defp find_by_schedule(dates, :teenth), do: Enum.find(dates, &(&1.day in @teenths))
end
