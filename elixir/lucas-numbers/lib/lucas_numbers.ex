defmodule LucasNumbers do
  @two_first_numbers [2, 1]

  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(count) when is_integer(count) and count >= 1 do
    @two_first_numbers
    |> List.to_tuple()
    |> Stream.iterate(fn {prev, curr} -> {curr, prev + curr} end)
    |> Stream.map(fn {_, curr} -> curr end)
    |> then(&Stream.concat([List.first(@two_first_numbers)], &1))
    |> Enum.take(count)
  end

  def generate(_) do
    raise ArgumentError, "count must be specified as an integer >= 1"
  end
end
