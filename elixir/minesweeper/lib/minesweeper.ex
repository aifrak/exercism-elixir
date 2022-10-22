defmodule Minesweeper do
  @mine "*"
  @empty " "

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]

  def annotate(board),
    do: board |> Enum.map(&String.graphemes/1) |> annotate_board() |> Enum.map(&Enum.join/1)

  defp annotate_board(board),
    do: board |> Enum.with_index() |> Enum.map(&annotate_row(&1, board))

  defp annotate_row({row, x}, board) do
    row
    |> Enum.with_index()
    |> Enum.map(fn
      {@mine, _} -> @mine
      {_, y} -> annotate_cell({x, y}, board)
    end)
  end

  defp annotate_cell(coordinates, board),
    do: coordinates |> adjacents(board) |> Enum.count(&(&1 == @mine)) |> zero_to_empty()

  defp zero_to_empty(0), do: @empty
  defp zero_to_empty(count), do: count

  defp adjacents(coordinates, board) do
    [
      get_in(board, adjacent_keys(coordinates, :top)),
      get_in(board, adjacent_keys(coordinates, :top_right)),
      get_in(board, adjacent_keys(coordinates, :right)),
      get_in(board, adjacent_keys(coordinates, :bottom_left)),
      get_in(board, adjacent_keys(coordinates, :bottom)),
      get_in(board, adjacent_keys(coordinates, :bottom_right)),
      get_in(board, adjacent_keys(coordinates, :left)),
      get_in(board, adjacent_keys(coordinates, :top_left))
    ]
  end

  defp adjacent_keys({x, y}, location)
       when (x == 0 and location in [:top, :top_right, :top_left]) or
              (y == 0 and location in [:bottom_left, :left, :top_left]),
       do: [nil]

  defp adjacent_keys({x, y}, :top), do: [Access.at(x - 1), Access.at(y)]
  defp adjacent_keys({x, y}, :top_right), do: [Access.at(x - 1), Access.at(y + 1)]
  defp adjacent_keys({x, y}, :right), do: [Access.at(x), Access.at(y + 1)]
  defp adjacent_keys({x, y}, :bottom_left), do: [Access.at(x + 1), Access.at(y - 1)]
  defp adjacent_keys({x, y}, :bottom), do: [Access.at(x + 1), Access.at(y)]
  defp adjacent_keys({x, y}, :bottom_right), do: [Access.at(x + 1), Access.at(y + 1)]
  defp adjacent_keys({x, y}, :left), do: [Access.at(x), Access.at(y - 1)]
  defp adjacent_keys({x, y}, :top_left), do: [Access.at(x - 1), Access.at(y - 1)]
end
