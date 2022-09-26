defmodule StateOfTicTacToe do
  @player_x "X"
  @player_o "O"
  @empty "."

  defguardp is_player(char) when <<char>> in [@player_x, @player_o]

  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    with :ok <- validate_turn_order(board),
         :ok <- validate_win(board),
         state <- do_game_state(board) do
      {:ok, state}
    end
  end

  defp do_game_state(board) do
    rows = String.split(board)

    cond do
      win?(@player_x, rows) or win?(@player_o, rows) -> :win
      String.contains?(board, @empty) -> :ongoing
      true -> :draw
    end
  end

  defp validate_win(board) do
    rows = String.split(board)

    if win?(@player_x, rows) and win?(@player_o, rows),
      do: {:error, "Impossible board: game should have ended after the game was won"},
      else: :ok
  end

  defp validate_turn_order(board) do
    frequencies = board |> String.graphemes() |> Enum.frequencies()
    x_count = Map.get(frequencies, @player_x, 0)
    o_count = Map.get(frequencies, @player_o, 0)

    cond do
      x_count - 1 > o_count -> {:error, "Wrong turn order: X went twice"}
      x_count < o_count -> {:error, "Wrong turn order: O started"}
      true -> :ok
    end
  end

  defp win?(<<c>>, [
         <<c, c, c>>,
         _,
         _
       ])
       when is_player(c),
       do: true

  defp win?(<<c>>, [
         _,
         <<c, c, c>>,
         _
       ])
       when is_player(c),
       do: true

  defp win?(<<c>>, [
         _,
         _,
         <<c, c, c>>
       ])
       when is_player(c),
       do: true

  defp win?(<<c>>, [
         <<c, _, _>>,
         <<c, _, _>>,
         <<c, _, _>>
       ])
       when is_player(c),
       do: true

  defp win?(<<c>>, [
         <<_, c, _>>,
         <<_, c, _>>,
         <<_, c, _>>
       ])
       when is_player(c),
       do: true

  defp win?(<<c>>, [
         <<_, _, c>>,
         <<_, _, c>>,
         <<_, _, c>>
       ])
       when is_player(c),
       do: true

  defp win?(<<c>>, [
         <<_, _, c>>,
         <<_, c, _>>,
         <<c, _, _>>
       ])
       when is_player(c),
       do: true

  defp win?(<<c>>, [
         <<c, _, _>>,
         <<_, c, _>>,
         <<_, _, c>>
       ])
       when is_player(c),
       do: true

  defp win?(_, _), do: false
end
