defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input), do: input |> Enum.reduce(%{}, &add_scores/2) |> print()

  defp add_scores(match_str, all_results) do
    case Match.new(match_str) do
      {:ok, match} -> score_match(all_results, match)
      {:error, _} -> all_results
    end
  end

  defp score_match(all_results, match),
    do: all_results |> score_team(match.team_a, match) |> score_team(match.team_b, match)

  defp score_team(all_results, name, match),
    do: Map.update(all_results, name, Team.new(name, match), &Team.tally(&1, match))

  defp print(scores) do
    scores
    |> Map.values()
    |> Enum.sort_by(& &1.points, :desc)
    |> then(&[header() | &1])
    |> Enum.map_join("\n", &to_row/1)
  end

  defp to_row(value) when is_binary(value), do: value

  defp to_row(%Team{} = team) do
    header_row(team.name) <>
      cell(team.played) <>
      cell(team.won) <>
      cell(team.drawn) <>
      cell(team.lost) <>
      cell(team.points)
  end

  defp cell(value) when is_integer(value), do: value |> Integer.to_string() |> cell()
  defp cell(value), do: " | " <> String.pad_leading(value, 2)

  defp header_row(name), do: String.pad_trailing(name, 30)

  defp header(),
    do: header_row("Team") <> cell("MP") <> cell("W") <> cell("D") <> cell("L") <> cell("P")
end
