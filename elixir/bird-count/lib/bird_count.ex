defmodule BirdCount do
  @busy_day_threshold 5

  def today([]), do: nil
  def today([first | _tail]), do: first

  def increment_day_count([]), do: [1]
  def increment_day_count([count | tail]), do: [count + 1 | tail]

  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([count | _tail]) when count == 0, do: true
  def has_day_without_birds?([_count | tail]), do: has_day_without_birds?(tail)

  def total(list), do: total(list, 0)
  def busy_days(list), do: busy_days(list, 0)

  defp total([], total), do: total
  defp total([count | tail], total), do: total(tail, count + total)

  defp busy_days([], total), do: total

  defp busy_days([count | tail], total) when count >= @busy_day_threshold,
    do: busy_days(tail, total + 1)

  defp busy_days([_count | tail], total), do: busy_days(tail, total)
end
