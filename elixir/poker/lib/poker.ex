defmodule Poker do
  @ace_low 1

  @ranks ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
         |> Enum.with_index(2)
         |> Map.new()

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
    [best_hand | _] =
      parsed_hands =
      hands |> Enum.map(&parsed_hand/1) |> Enum.sort(fn a, b -> compare_hand(a, b) != :lt end)

    parsed_hands
    |> Enum.take_while(&same_hand_rank?(&1, best_hand))
    |> Enum.map(& &1.hand)
  end

  defp parsed_hand(hand) do
    hand
    |> Enum.map(&parse_card/1)
    |> Enum.group_by(fn {rank, _, _} -> rank end)
    |> Enum.group_by(fn {_, cards} -> Enum.count(cards) end, fn {_, cards} -> cards end)
    |> Enum.sort(fn {count_1, _}, {count_2, _} -> count_1 > count_2 end)
    |> Enum.flat_map(fn {_, cards} ->
      cards |> List.flatten() |> Enum.sort_by(&point/1, :desc) |> may_slide_ace_to_low()
    end)
    |> then(
      &%{hand: hand, cards: &1, rank: &1 |> best_rank() |> then(fn br -> {br, @hands[br]} end)}
    )
  end

  defp parse_card(str) do
    ~r/(?<rank>[2-9]|10|[JQKA])(?<suit>[CDHS])/
    |> Regex.named_captures(str)
    |> then(fn %{"rank" => rank, "suit" => suit} -> {rank, suit, @ranks[rank]} end)
  end

  defp best_rank([{_, s, p1}, {_, s, p2}, {_, s, p3}, {_, s, p4}, {_, s, p5}])
       when is_sequential(p1, p2, p3, p4, p5),
       do: :straight_flush

  defp best_rank([{r1, _, _}, {r1, _, _}, {r1, _, _}, {r1, _, _}, _]), do: :four_of_a_kind
  defp best_rank([{r1, _, _}, {r1, _, _}, {r1, _, _}, {r2, _, _}, {r2, _, _}]), do: :full_house

  defp best_rank([{_, _, p1}, {_, _, p2}, {_, _, p3}, {_, _, p4}, {_, _, p5}])
       when is_sequential(p1, p2, p3, p4, p5),
       do: :straight

  defp best_rank([{_, s, _}, {_, s, _}, {_, s, _}, {_, s, _}, {_, s, _}]), do: :flush
  defp best_rank([{r1, _, _}, {r1, _, _}, {r1, _, _}, _, _]), do: :three_of_a_kind
  defp best_rank([{r1, _, _}, {r1, _, _}, {r2, _, _}, {r2, _, _}, _]), do: :two_pair
  defp best_rank([{r1, _, _}, {r1, _, _}, _, _, _]), do: :one_pair
  defp best_rank(_), do: :high_card

  defp compare_hand(%{rank: {_, rp1}} = h1, %{rank: {_, rp2}} = h2) do
    cond do
      rp1 > rp2 -> :gt
      rp1 < rp2 -> :lt
      true -> compare_cards(h1.cards, h2.cards)
    end
  end

  defp compare_cards([], []), do: :eq

  defp compare_cards([{_, _, p1} | tl1], [{_, _, p2} | tl2]) do
    cond do
      p1 > p2 -> :gt
      p1 < p2 -> :lt
      true -> compare_cards(tl1, tl2)
    end
  end

  defp may_slide_ace_to_low([
         {"A", s, _} | [{"5", _, _}, {"4", _, _}, {"3", _, _}, {"2", _, _}] = rest
       ]) do
    rest ++ [{"A", s, @ace_low}]
  end

  defp may_slide_ace_to_low(hand), do: hand

  defp same_hand_rank?(%{rank: {r1, _}, cards: c1}, %{rank: {r2, _}, cards: c2}),
    do: r1 == r2 and compare_cards(c1, c2) == :eq

  defp point({_, _, point}), do: point
end
