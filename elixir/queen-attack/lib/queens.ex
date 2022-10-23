defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @max 7
  @axis_range 0..@max

  @empty "_"
  @black "B"
  @white "W"

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    with :ok <- validate_keys(opts),
         black <- opts[:black],
         white <- opts[:white],
         :ok <- validate_inside_board(black),
         :ok <- validate_inside_board(white),
         :ok <- validate_different_locations(black, white) do
      %__MODULE__{black: opts[:black], white: opts[:white]}
    end
  end

  defp validate_keys(opts),
    do: if(count_invalid_keys(opts) == 0, do: :ok, else: raise(ArgumentError))

  defp count_invalid_keys(opts),
    do: opts |> Keyword.reject(fn {k, _} -> k in [:black, :white] end) |> Enum.count()

  defp validate_inside_board(nil), do: :ok
  defp validate_inside_board({x, y}) when x in @axis_range and y in @axis_range, do: :ok
  defp validate_inside_board(_), do: raise(ArgumentError)

  defp validate_different_locations(piece, piece), do: raise(ArgumentError)
  defp validate_different_locations(_, _), do: :ok

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(opts), do: opts |> board() |> Enum.map_join("\n", &Enum.join(&1, " "))

  defp board(%{black: black, white: white}) do
    for x <- @axis_range do
      for y <- @axis_range do
        case {x, y} do
          ^black -> @black
          ^white -> @white
          _ -> @empty
        end
      end
    end
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%{black: nil}), do: false
  def can_attack?(%{white: nil}), do: false
  def can_attack?(%{black: {x, _}, white: {x, _}}), do: true
  def can_attack?(%{black: {_, y}, white: {_, y}}), do: true

  def can_attack?(%{black: black, white: white}), do: black |> diagonals() |> Enum.member?(white)

  defp diagonals({x, y}) do
    for offset <- 1..(@max - 1) do
      [
        {x + offset, y + offset},
        {x + offset, y - offset},
        {x - offset, y + offset},
        {x - offset, y - offset}
      ]
    end
    |> List.flatten()
  end
end
