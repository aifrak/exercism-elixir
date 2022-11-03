defmodule BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5

  @base_price 800
  @discounts %{1 => 0, 2 => 5, 3 => 10, 4 => 20, 5 => 25}
  @size_max @discounts |> Map.keys() |> Enum.max()

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket :: [book]) :: integer
  def total(basket) do
    2..@size_max
    |> Enum.map(&min(calculate(group(basket, &1)), calculate(group_then_zip_solos(basket, &1))))
    |> Enum.min()
  end

  defp calculate(groups), do: Enum.reduce(groups, 0, &(net_price(length(&1)) + &2))

  defp net_price(quantity), do: @base_price * quantity * (1 - @discounts[quantity] / 100)

  defp group_then_zip_solos(basket, size) do
    {solos, rest} = Enum.split_with(basket, &uniq?(basket, &1))
    rest |> group(size) |> Enum.sort_by(&Enum.count/1, :desc) |> zip(solos)
  end

  defp uniq?(basket, elem), do: Enum.count(basket, &(&1 == elem)) == 1

  defp group(basket, size, acc \\ [])
  defp group([], _, acc), do: acc

  defp group([book | tl], size, acc) do
    index = Enum.find_index(acc, &(not Enum.member?(&1, book) and length(&1) < size))

    if is_integer(index),
      do: group(tl, size, update_in(acc, [Access.at(index)], &[book | &1])),
      else: group(tl, size, [[book] | acc])
  end

  defp zip(groups, solos, acc \\ [])
  defp zip([], [], acc), do: acc
  defp zip([], solos, acc), do: [solos | acc]
  defp zip(groups, [], acc), do: groups ++ acc

  defp zip([group | g_tl], [book | s_tl], acc) when length(group) < @size_max - 1,
    do: zip(g_tl, s_tl, [[book | group] | acc])

  defp zip([hd | tl], solos, acc), do: zip(tl, solos, [hd | acc])
end
