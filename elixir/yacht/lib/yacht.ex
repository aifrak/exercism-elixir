defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer

  def score(:ones, dice), do: sum(1, dice)
  def score(:twos, dice), do: sum(2, dice)
  def score(:threes, dice), do: sum(3, dice)
  def score(:fours, dice), do: sum(4, dice)
  def score(:fives, dice), do: sum(5, dice)
  def score(:sixes, dice), do: sum(6, dice)
  def score(:choice, dice), do: Enum.sum(dice)
  def score(:yacht, [a, a, a, a, a]), do: 50
  def score(category, dice), do: do_score(category, Enum.sort(dice))

  defp do_score(:full_house, [a, a, a, b, b] = dice) when a != b, do: Enum.sum(dice)
  defp do_score(:full_house, [a, a, b, b, b] = dice) when a != b, do: Enum.sum(dice)
  defp do_score(:four_of_a_kind, [a, a, a, a, _]), do: a * 4
  defp do_score(:four_of_a_kind, [_, a, a, a, a]), do: a * 4
  defp do_score(:little_straight, [1, 2, 3, 4, 5]), do: 30
  defp do_score(:big_straight, [2, 3, 4, 5, 6]), do: 30
  defp do_score(_, _), do: 0

  defp sum(number, dice), do: dice |> Enum.filter(&(&1 == number)) |> Enum.sum()
end
