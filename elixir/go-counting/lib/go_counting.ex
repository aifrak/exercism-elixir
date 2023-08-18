defmodule GoCounting do
  @type position :: {integer, integer}
  @type owner :: %{owner: atom, territory: [position]}
  @type territories :: %{white: [position], black: [position], none: [position]}

  @line_separator "\n"
  @players %{?B => :black, ?W => :white, ?_ => :none}

  @doc """
  Return the owner and territory around a position
  """
  @spec territory(board :: String.t(), position :: position) ::
          {:ok, owner} | {:error, String.t()}
  def territory(board, pos) do
    with :ok <- validate_coordinates(board, pos),
         do: board |> parse() |> do_territory(pos) |> then(&{:ok, &1})
  end

  defp validate_coordinates(board, {x, y}) do
    max = max_index(board)
    if x < 0 or y < 0 or x > max or y > max, do: {:error, "Invalid coordinate"}, else: :ok
  end

  defp max_index(board) do
    ~r/^.*(?=#{@line_separator})/ |> Regex.run(board) |> hd() |> String.length() |> Kernel.-(1)
  end

  defp parse(board) do
    for {row, y} <- board |> String.split(@line_separator) |> Enum.with_index(),
        {char, x} <- row |> to_charlist() |> Enum.with_index(),
        into: %{} do
      to_cell(x, y, char)
    end
  end

  defp do_territory(board, pos) do
    board
    |> territory_with_borders(pos)
    |> then(&%{owner: owner(&1), territory: nones(&1)})
  end

  defp owner(board, player \\ :none)
  defp owner([], player), do: player
  defp owner([{_, :black} | _], :white), do: :none
  defp owner([{_, :white} | _], :black), do: :none
  defp owner([{_, :none} | tl], player), do: owner(tl, player)
  defp owner([{_, player} | tl], _), do: owner(tl, player)

  defp territory_with_borders(board, pos) do
    {_, player} = cell = to_cell(board, pos)
    if player == :none, do: territory_with_borders(board, [pos], [cell]), else: []
  end

  defp territory_with_borders(board, positions, visited)
  defp territory_with_borders(_, [], visited), do: Enum.sort(visited)

  defp territory_with_borders(board, positions, visited) do
    positions
    |> Enum.flat_map(&adjacencies/1)
    |> Enum.map(&to_cell(board, &1))
    |> Enum.reject(fn {_, player} = cell -> player == nil or cell in visited end)
    |> then(&territory_with_borders(board, nones(&1), &1 ++ visited))
  end

  defp adjacencies(position) do
    [
      adjacency(position, :top),
      adjacency(position, :right),
      adjacency(position, :bottom),
      adjacency(position, :left)
    ]
  end

  defp adjacency({x, y}, location) do
    case location do
      :top -> {x, y - 1}
      :right -> {x + 1, y}
      :bottom -> {x, y + 1}
      :left -> {x - 1, y}
    end
  end

  defp to_cell(x, y, char), do: {{x, y}, @players[char]}
  defp to_cell(board, position), do: {position, board[position]}

  defp nones(cells), do: cells |> Enum.filter(&(elem(&1, 1) == :none)) |> Enum.map(&elem(&1, 0))

  @doc """
  Return all white, black and neutral territories
  """
  @spec territories(board :: String.t()) :: territories
  def territories(board) do
    parsed_board = parse(board)

    parsed_board
    |> Map.to_list()
    |> do_territories(parsed_board)
  end

  defp do_territories(cells, board, acc \\ %{black: [], none: [], white: []}, visited \\ [])

  defp do_territories([], _, acc, _),
    do: acc |> Enum.map(fn {k, v} -> {k, Enum.sort(v)} end) |> Map.new()

  defp do_territories([{position, :none} | tl], board, acc, visited) do
    if position in visited do
      do_territories(tl, board, acc, visited)
    else
      %{owner: owner, territory: territory} = do_territory(board, position)
      do_territories(tl, board, update_in(acc[owner], &(territory ++ &1)), territory ++ visited)
    end
  end

  defp do_territories([_ | tl], board, acc, visited), do: do_territories(tl, board, acc, visited)
end
