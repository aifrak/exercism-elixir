defmodule Rectangles do
  @doc """
  Count the number of ASCII rectangles.
  """
  @spec count(input :: String.t()) :: integer
  def count(input) do
    parsed = String.split(input, "\n")
    parsed |> vertex_columns() |> then(&do_count(parsed, &1))
  end

  defp do_count(parsed, columns) do
    for first <- columns, last <- columns, first < last, reduce: 0 do
      acc -> parsed |> Enum.map(&parse_row(&1, first, last)) |> count_by_column() |> Kernel.+(acc)
    end
  end

  defp vertex_columns(parsed),
    do: for(row <- parsed, [{y, _}] <- Regex.scan(~r/\+/, row, return: :index), uniq: true, do: y)

  defp parse_row(row, first_index, last_index) do
    {first, rest} = row |> String.slice(first_index..last_index) |> String.split_at(1)
    {between, last} = String.split_at(rest, -1)
    {first, between, last}
  end

  defp count_by_column(rows, counts \\ [], rectangle_started? \\ false)
  defp count_by_column([], counts, _), do: counts |> Enum.map(&Enum.sum(0..&1)) |> Enum.sum()

  defp count_by_column([{"+", between, "+"} | tl], counts, false),
    do: count_by_column(tl, [0 | counts], String.match?(between, ~r/^[+|-]*$/))

  defp count_by_column([{"+", between, "+"} | tl], [count | rest] = counts, true) do
    if String.match?(between, ~r/^[+|-]*$/),
      do: count_by_column(tl, [count + 1 | rest], true),
      else: count_by_column(tl, [0 | counts], false)
  end

  defp count_by_column([{first, _, last} | tl], counts, rectangle_started?)
       when first in ["+", "|"] and last in ["+", "|"],
       do: count_by_column(tl, counts, rectangle_started?)

  defp count_by_column([_ | tl], counts, _), do: count_by_column(tl, counts, false)
end
