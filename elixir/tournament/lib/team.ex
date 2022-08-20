defmodule Team do
  @enforce_keys [:name]
  defstruct [:name, played: 0, won: 0, drawn: 0, lost: 0, points: 0]

  @type t :: %__MODULE__{
          name: String.t(),
          played: integer(),
          won: integer(),
          drawn: integer(),
          lost: integer(),
          points: integer()
        }

  defguardp won_as_team_a(team, match) when team.name == match.team_a and match.winner == :team_a
  defguardp won_as_team_b(team, match) when team.name == match.team_b and match.winner == :team_b

  @spec new(String.t()) :: Team.t()
  def new(name), do: %__MODULE__{name: name}

  @spec new(String.t(), Match.t()) :: t
  def new(team, match), do: team |> new() |> tally(match)

  @spec tally(t, Match.t()) :: t
  def tally(team, match) when won_as_team_a(team, match) or won_as_team_b(team, match),
    do: %{team | played: team.played + 1, won: team.won + 1, points: team.points + 3}

  def tally(team, %{winner: :draw}),
    do: %{team | played: team.played + 1, drawn: team.drawn + 1, points: team.points + 1}

  def tally(team, _), do: %{team | played: team.played + 1, lost: team.lost + 1}
end
