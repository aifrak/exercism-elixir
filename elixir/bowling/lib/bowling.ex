defmodule Bowling do
  @strike 10
  @spare 10
  @frames 10

  @type t :: %__MODULE__{frames: [[0..10]]}
  defstruct frames: []

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start, do: %__MODULE__{}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}

  def roll(game, roll) do
    with :ok <- validate_game_in_progress(game.frames),
         reversed_frames <- Enum.reverse(game.frames),
         :ok <- validate_pin_count(reversed_frames, roll) do
      {:ok, %{game | frames: reversed_frames |> do_roll(roll) |> Enum.reverse()}}
    end
  end

  defp validate_game_in_progress(frames),
    do: if(game_over?(frames), do: {:error, "Cannot roll after game is over"}, else: :ok)

  defp validate_pin_count(frames, roll) do
    if roll <= @strike and valid_pin_count?(frames, roll),
      do: :ok,
      else: {:error, "Pin count exceeds pins on the lane"}
  end

  defp valid_pin_count?(reversed_frames, roll)
  defp valid_pin_count?([], _), do: true
  defp valid_pin_count?([[@strike] | _], _), do: true
  defp valid_pin_count?([[_, @strike] | _], _), do: true
  defp valid_pin_count?([[r1] | _], r) when r1 + r <= @spare, do: true
  defp valid_pin_count?([[r1, r2] | _], r) when r1 + r2 <= @spare or r2 + r <= @spare, do: true
  defp valid_pin_count?(_, _), do: false

  defp do_roll(reversed_frames, roll)
  defp do_roll([[r1] | tl], r), do: [[r1, r] | tl]
  defp do_roll([[r1, r2] | tl] = f, r) when length(f) == @frames, do: [[r1, r2, r] | tl]
  defp do_roll(f, @strike) when length(f) == @frames - 1, do: [[@strike] | f]
  defp do_roll(f, @strike), do: [[@strike, 0] | f]
  defp do_roll(f, r), do: [[r] | f]

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}

  def score(%{frames: frames}) do
    if game_over?(frames),
      do: {:ok, do_score(frames)},
      else: {:error, "Score cannot be taken until the end of the game"}
  end

  defp do_score(frames, acc \\ 0)
  defp do_score([], acc), do: acc

  defp do_score([[@strike, _], [@strike, _] = f2, [r1 | _] = last_frame | tl], acc),
    do: do_score([f2, last_frame | tl], @strike + @strike + r1 + acc)

  defp do_score([[@strike, _], [r1, r2 | _] = f2 | tl], acc),
    do: do_score([f2 | tl], @strike + r1 + r2 + acc)

  defp do_score([[r1, r2], [r3, _] = f2 | tl], acc) when r1 + r2 == @spare,
    do: do_score([f2 | tl], @spare + r3 + acc)

  defp do_score([f1 | tl], acc), do: do_score(tl, Enum.sum(f1) + acc)

  defp game_over?(frames) do
    length(frames) == @frames and
      match?([r1, r2 | _] = f when r1 + r2 < @spare or length(f) == 3, List.last(frames))
  end
end
