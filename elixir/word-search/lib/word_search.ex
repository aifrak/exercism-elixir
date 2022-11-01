defmodule WordSearch do
  defmodule Location do
    defstruct [:from, :to]

    @type t :: %Location{
            from: %{row: integer, column: integer},
            to: %{row: integer, column: integer}
          }
  end

  @doc """
  Find the start and end positions of words in a grid of letters.
  Row and column positions are 1 indexed.
  """
  @spec search(grid :: String.t(), words :: [String.t()]) :: %{String.t() => nil | Location.t()}
  def search(grid, words) do
    coordinates = coordinates(grid)
    words |> Enum.map(&locations(&1, coordinates)) |> Map.new()
  end

  defp coordinates(grid) do
    for {row, x} <- grid |> String.split("\n") |> Enum.with_index(1),
        {char, y} <- row |> String.graphemes() |> Enum.with_index(1),
        reduce: %{} do
      acc -> Map.update(acc, char, [{x, y}], &[{x, y} | &1])
    end
  end

  defp locations(word, coordinates),
    do: {word, find(word, String.graphemes(word), coordinates) |> to_location()}

  defp to_location([]), do: nil

  defp to_location(coordinates) do
    {from_row, from_col} = List.first(coordinates)
    {to_row, to_col} = List.last(coordinates)
    %Location{from: %{row: from_row, column: from_col}, to: %{row: to_row, column: to_col}}
  end

  defp find(word, chars, coordinates, read \\ "", found \\ [])
  defp find(word, _, _, word, found), do: Enum.reverse(found)
  defp find(_, [], _, _, _), do: []
  defp find(_, _, [], _, _), do: []

  defp find(word, [char | rest], coordinates, read, found) do
    prev_char_coord = List.first(found)

    coordinates
    |> Map.get(char, [])
    |> Enum.reduce_while([], fn char_coord, acc ->
      with true <- adjacent?(char_coord, prev_char_coord),
           next_coordinates = next_coordinates(coordinates, char, char_coord),
           result = find(word, rest, next_coordinates, read <> char, [char_coord | found]),
           true <- all_same_direction?(result) do
        {:halt, result}
      else
        _ -> {:cont, acc}
      end
    end)
  end

  defp adjacent?(_, nil), do: true
  defp adjacent?({x1, y1}, {x2, y2}), do: abs(x1 - x2) in [0, 1] and abs(y1 - y2) in [0, 1]

  defp next_coordinates(coordinates, char, coord),
    do: update_in(coordinates[char], &Enum.reject(&1, fn elem -> elem == coord end))

  defp all_same_direction?([]), do: false

  defp all_same_direction?([first, second | rest]) do
    initial_direction = direction(first, second)

    [second | rest]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> direction(a, b) == initial_direction end)
  end

  defp direction({x, y}, char_coordinates) do
    cond do
      {x - 1, y} == char_coordinates -> :top
      {x - 1, y + 1} == char_coordinates -> :top_right
      {x, y + 1} == char_coordinates -> :right
      {x + 1, y + 1} == char_coordinates -> :bottom_right
      {x + 1, y} == char_coordinates -> :bottom
      {x + 1, y - 1} == char_coordinates -> :bottom_left
      {x, y - 1} == char_coordinates -> :left
      {x - 1, y - 1} == char_coordinates -> :top_left
    end
  end
end
