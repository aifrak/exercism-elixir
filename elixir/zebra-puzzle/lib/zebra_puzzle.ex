defmodule ZebraPuzzle do
  alias House

  # 1. There are five houses.
  @house_size 5

  @puzzle [
    # 2. The Englishman lives in the red house.
    %House{nationality: :englishman, color: :red},
    # 3. The Spaniard owns the dog.
    %House{nationality: :spaniard, pet: :dog},
    # 4. Coffee is drunk in the green house.
    %House{drink: :coffee, color: :green},
    # 5. The Ukrainian drinks tea.
    %House{nationality: :ukrainian, drink: :tea},
    # 6. The green house is immediately to the right of the ivory house.
    %House{color: :green, location: :right, neighbor: %House{color: :ivory}},
    # 7. The Old Gold smoker owns snails.
    %House{cigarette: :old_gold, pet: :snails},
    # 8. Kools are smoked in the yellow house.
    %House{cigarette: :kools, color: :yellow},
    # 9. Milk is drunk in the middle house.
    %House{drink: :milk, location: :middle},
    # 10. The Norwegian lives in the first house.
    %House{nationality: :norwegian, location: :first},
    # 11. The man who smokes Chesterfields lives in the house next to the man with the fox.
    %House{cigarette: :chesterfields, location: :next, neighbor: %House{pet: :fox}},
    # 12. Kools are smoked in the house next to the house where the horse is kept.
    %House{cigarette: :kools, location: :next, neighbor: %House{pet: :horse}},
    # 13. The Lucky Strike smoker drinks orange juice.
    %House{cigarette: :lucky_strike, drink: :orange_juice},
    # 14. The Japanese smokes Parliaments.
    %House{nationality: :japanese, cigarette: :parliaments},
    # 15. The Norwegian lives next to the blue house.
    %House{nationality: :norwegian, location: :next, neighbor: %House{color: :blue}}
  ]

  @puzzle_houses_with_next_location Enum.filter(@puzzle, &(&1.location == :next))
  @all_neighbors_pairs for(
                         i <- 0..(@house_size - 1),
                         j <- 0..(@house_size - 1),
                         i + 1 == j or j + 1 == i,
                         do: {i, j}
                       )

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    solve()
    |> get_in([Access.filter(&(&1.drink == :water)), Access.key(:nationality)])
    |> List.first()
  end

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
    solve()
    |> get_in([Access.filter(&(&1.pet == :zebra)), Access.key(:nationality)])
    |> List.first()
  end

  defp solve() do
    all_potential_houses()
    |> then(&Enum.map(1..@house_size, fn _ -> &1 end))
    # first
    |> filter_houses(0, :nationality, :norwegian)
    |> reject_other_houses(0, :nationality, :norwegian)
    # next to first (norwegian house)
    |> filter_houses(1, :color, :blue)
    |> reject_other_houses(1, :color, :blue)
    #  middle
    |> filter_houses(2, :drink, :milk)
    |> reject_other_houses(2, :drink, :milk)
    # only possible neighbor of "right" house
    |> filter_houses(3, :color, :ivory)
    |> reject_other_houses(3, :color, :ivory)
    # only possible "right" house
    |> filter_houses(4, :color, :green)
    |> reject_other_houses(4, :color, :green)
    |> solve_location_next(@puzzle_houses_with_next_location)
    |> solve_last_unknown_house()
    |> List.flatten()
  end

  defp filter_houses(houses, index, key, value) do
    update_in(
      houses,
      [Access.at(index)],
      &Enum.filter(&1, fn h -> get_in(h, [Access.key(key)]) == value end)
    )
  end

  defp reject_other_houses(houses, index, key, value) do
    for i <- 0..(@house_size - 1), i != index, reduce: houses do
      acc ->
        update_in(
          acc,
          [Access.at(i)],
          &Enum.reject(&1, fn h -> get_in(h, [Access.key(key)]) == value end)
        )
    end
  end

  defp all_potential_houses() do
    for nationality <- House.nationalities(),
        cigarette <- House.cigarettes(),
        color <- House.colors(),
        drink <- House.drinks(),
        pet <- House.pets(),
        house = %House{
          nationality: nationality,
          color: color,
          cigarette: cigarette,
          drink: drink,
          pet: pet
        },
        potential?(house) do
      house
    end
  end

  defp potential?(house) do
    h = filter_filled_keys(house)

    Enum.all?(@puzzle, fn
      %{location: nil, neighbor: nil} = puzzle_house ->
        ph = filter_filled_keys(puzzle_house)
        not similar?(ph, house) or ph == Map.take(h, Map.keys(ph))

      %{neighbor: neighbor} = puzzle_house when neighbor != nil ->
        ph = filter_filled_keys(puzzle_house)
        n = filter_filled_keys(neighbor)
        not similar?(ph, house) or n != Map.take(h, Map.keys(n))

      _ ->
        true
    end)
  end

  defp filter_filled_keys(house) do
    house
    |> Map.from_struct()
    |> Map.filter(fn {k, v} ->
      v != nil and k in [:nationality, :color, :cigarette, :drink, :pet]
    end)
  end

  defp similar?(m1, m2), do: Enum.any?(m1, fn {k, v} -> Map.get(m2, k) == v end)

  defp solve_location_next(houses, []), do: houses

  defp solve_location_next(houses, [%{neighbor: neighbor} = puzzle_house | tl]) do
    [{phk, phv}] = puzzle_house |> filter_filled_keys() |> Map.to_list()
    [{nk, nv}] = neighbor |> filter_filled_keys() |> Map.to_list()

    Enum.reduce_while(@all_neighbors_pairs, houses, fn {i, j}, acc ->
      new_houses =
        houses
        |> filter_houses(i, phk, phv)
        |> reject_other_houses(i, phk, phv)
        |> filter_houses(j, nk, nv)
        |> reject_other_houses(j, nk, nv)

      with false <- Enum.any?(new_houses, &Enum.empty?/1),
           result = solve_location_next(new_houses, tl),
           %{1 => singles} when length(singles) == @house_size - 1 <-
             Enum.group_by(result, &Enum.count/1) do
        {:halt, result}
      else
        _ -> {:cont, acc}
      end
    end)
  end

  defp solve_last_unknown_house(houses) do
    houses
    |> Enum.with_index()
    |> Enum.map(fn
      {potential_houses, i} when length(potential_houses) > 1 ->
        houses
        |> List.delete_at(i)
        |> get_in([Access.all(), Access.all(), Access.key(:nationality)])
        |> then(&Enum.find(potential_houses, fn h -> h.nationality not in &1 end))

      {potential_houses, _} ->
        potential_houses
    end)
  end
end
