defmodule Poker do
  @ranks ~w(2 3 4 5 6 7 8 9 10 J Q K A) |> Enum.with_index(2) |> Map.new()
  @ace_high @ranks["A"]
  @ace_low 1

  @hands [
           :high_card,
           :one_pair,
           :two_pair,
           :three_of_a_kind,
           :straight,
           :flush,
           :full_house,
           :four_of_a_kind,
           :straight_flush
         ]
         |> Enum.with_index()
         |> Map.new()

  defguardp is_sequential(p1, p2, p3, p4, p5)
            when p1 - 1 == p2 and p2 - 1 == p3 and p3 - 1 == p4 and p4 - 1 == p5

  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    hands
    |> Enum.map(&parsed_hand/1)
    |> Enum.sort_by(&{&1.rank, &1.cards}, :desc)
    |> then(fn [best_hand | _] = parsed_hands ->
      parsed_hands |> Enum.take_while(&same_hand_rank?(&1, best_hand)) |> Enum.map(& &1.hand)
    end)
  end

  defp same_hand_rank?(h1, h2), do: h1.rank == h2.rank and h1.cards == h2.cards

  defp parsed_hand(hand) do
    hand
    |> Enum.map(&parse_card/1)
    |> Enum.group_by(fn {rank, _} -> rank end)
    |> Enum.group_by(fn {_, cards} -> Enum.count(cards) end, fn {_, cards} -> cards end)
    |> Enum.sort(fn {count_1, _}, {count_2, _} -> count_1 > count_2 end)
    |> Enum.flat_map(fn {_, cards} ->
      cards |> List.flatten() |> List.keysort(0, :desc) |> may_slide_ace_to_low()
    end)
    |> then(&%{hand: hand, cards: Enum.map(&1, fn {r, _} -> r end), rank: best_rank(&1)})
  end

  defp may_slide_ace_to_low([{@ace_high, s} | [{5, _}, {4, _}, {3, _}, {2, _}] = rest]),
    do: rest ++ [{@ace_low, s}]

  defp may_slide_ace_to_low(hand), do: hand

  defp parse_card(str) do
    ~r/(?<rank>[2-9]|10|[JQKA])(?<suit>[CDHS])/
    |> Regex.named_captures(str)
    |> then(fn %{"rank" => rank, "suit" => suit} -> {@ranks[rank], suit} end)
  end

  defp best_rank([{r1, s}, {r2, s}, {r3, s}, {r4, s}, {r5, s}])
       when is_sequential(r1, r2, r3, r4, r5),
       do: @hands[:straight_flush]

  defp best_rank([{r1, _}, {r1, _}, {r1, _}, {r1, _}, _]), do: @hands[:four_of_a_kind]
  defp best_rank([{r1, _}, {r1, _}, {r1, _}, {r2, _}, {r2, _}]), do: @hands[:full_house]

  defp best_rank([{r1, _}, {r2, _}, {r3, _}, {r4, _}, {r5, _}])
       when is_sequential(r1, r2, r3, r4, r5),
       do: @hands[:straight]

  defp best_rank([{_, s}, {_, s}, {_, s}, {_, s}, {_, s}]), do: @hands[:flush]
  defp best_rank([{r1, _}, {r1, _}, {r1, _}, _, _]), do: @hands[:three_of_a_kind]
  defp best_rank([{r1, _}, {r1, _}, {r2, _}, {r2, _}, _]), do: @hands[:two_pair]
  defp best_rank([{r1, _}, {r1, _}, _, _, _]), do: @hands[:one_pair]
  defp best_rank(_), do: @hands[:high_card]
end
