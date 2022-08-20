defmodule Match do
  @regex ~r/^(?<team_a>[ \w]+);(?<team_b>[ \w]+);(?<result>win|loss|draw)$/

  @enforce_keys [:team_a, :team_b, :winner]
  defstruct [:team_a, :team_b, :winner]

  @typep winner :: :team_a | :team_b | :draw
  @type t :: %__MODULE__{team_a: String.t(), team_b: String.t(), winner: winner}

  @spec new(binary) :: {:ok, t} | {:error, :invalid_result}
  def new(match_str) do
    case Regex.named_captures(@regex, match_str) do
      %{"team_a" => team_a, "team_b" => team_b, "result" => result} ->
        {:ok, %__MODULE__{team_a: team_a, team_b: team_b, winner: winner(result)}}

      _ ->
        {:error, :invalid_result}
    end
  end

  defp winner("win"), do: :team_a
  defp winner("draw"), do: :draw
  defp winner("loss"), do: :team_b
end
