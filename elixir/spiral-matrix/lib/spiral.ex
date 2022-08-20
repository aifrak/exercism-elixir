defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []

  def matrix(dimension) do
    last_index = dimension - 1

    last_index
    |> new()
    |> fill({0, 0}, 1, %{axis: :x, step: 1, count: 0, max: last_index})
  end

  defp new(last_index) do
    for _ <- 0..last_index do
      for _ <- 0..last_index, do: 0
    end
  end

  defp fill(matrix, _, _, %{max: -1}), do: matrix

  defp fill(matrix, coordinates, number, move) do
    {x, y} = coordinates

    next_move = next_move(move)

    matrix
    |> put_in([Access.at(y), Access.at(x)], number)
    |> fill(next_coordinates(coordinates, next_move), number + 1, next_move)
  end

  defp next_coordinates({x, y}, %{axis: :x, step: step}), do: {x + step, y}
  defp next_coordinates({x, y}, %{axis: :y, step: step}), do: {x, y + step}

  defp next_move(%{axis: :x, count: max, max: max} = move),
    do: %{move | axis: :y, count: 0, max: max - 1}

  defp next_move(%{axis: :y, step: step, count: max, max: max} = move),
    do: %{move | axis: :x, count: 0, step: step * -1}

  defp next_move(move), do: Map.update!(move, :count, &(&1 + 1))
end
