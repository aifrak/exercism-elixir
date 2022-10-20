defmodule Connect do
  @players %{"X" => :black, "O" => :white}

  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board), do: board |> pieces() |> status(board_sizes(board))

  defp pieces(board), do: board |> Enum.with_index() |> Enum.flat_map(&parse_row/1)

  defp board_sizes(board) do
    x_size = length(board) - 1
    y_size = board |> Enum.at(0) |> row_to_array() |> length() |> Kernel.-(1)
    {x_size, y_size}
  end

  defp parse_row({row_str, x}) do
    row_str
    |> row_to_array()
    |> Enum.with_index()
    |> Enum.map(fn {player, y} -> new_piece(player, x, y) end)
    |> Enum.reject(&(&1.player == nil))
  end

  defp row_to_array(row_str),
    do: row_str |> String.trim_leading() |> String.replace(" ", "") |> String.graphemes()

  defp new_piece(player, x, y), do: %{player: @players[player], x: x, y: y}

  defp status(pieces, board_sizes) do
    {black, white} = Enum.split_with(pieces, fn %{player: player} -> player == :black end)

    cond do
      win?(black, board_sizes) -> :black
      win?(white, board_sizes) -> :white
      true -> :none
    end
  end

  defp win?(pieces, board_sizes),
    do: pieces |> chains() |> Enum.any?(&connect_sides?(&1, board_sizes))

  defp connect_sides?(_, {0, 0}), do: true

  defp connect_sides?(pieces, {x_size, y_size}),
    do: connect_sides?(pieces, :x, x_size) or connect_sides?(pieces, :y, y_size)

  defp connect_sides?(pieces, coordinate, size) do
    {piece_min, piece_max} = Enum.min_max_by(pieces, & &1[coordinate])
    min = piece_min[coordinate]
    max = piece_max[coordinate]
    max - min > 0 && {min, max} == {0, size}
  end

  defp chains(pieces, chains \\ [])
  defp chains([], chains), do: chains

  defp chains([piece | tl], chains),
    do: [piece] |> chain(tl) |> then(&chains(tl -- &1, [&1 | chains]))

  defp chain(pieces, available, chain \\ [])
  defp chain([], _, chain), do: chain

  defp chain([piece | tl], available, chain) do
    adjacents = piece |> potential_adjacents() |> Enum.filter(&Enum.member?(available, &1))
    chain = [piece | adjacents ++ chain]
    chain(adjacents ++ tl, available -- chain, chain)
  end

  defp potential_adjacents(piece) do
    [
      adjacent(piece, :top_left),
      adjacent(piece, :top_right),
      adjacent(piece, :right),
      adjacent(piece, :bottom_right),
      adjacent(piece, :bottom_left),
      adjacent(piece, :left)
    ]
  end

  defp adjacent(%{player: player, x: x, y: y}, location) do
    case location do
      :top_left -> %{player: player, x: x - 1, y: y}
      :top_right -> %{player: player, x: x - 1, y: y + 1}
      :right -> %{player: player, x: x, y: y + 1}
      :bottom_right -> %{player: player, x: x + 1, y: y}
      :bottom_left -> %{player: player, x: x + 1, y: y - 1}
      :left -> %{player: player, x: x, y: y - 1}
    end
  end
end
