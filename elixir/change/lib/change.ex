defmodule Change do
  @quantity_limit 5

  defguardp has_too_many_small_coins(coin, target)
            when coin < 10 and div(target, coin) > @quantity_limit

  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_, 0), do: {:ok, []}

  def generate(coins, target) do
    change = coins |> Enum.reverse() |> do_generate(target, [])
    if Enum.empty?(change), do: {:error, "cannot change"}, else: {:ok, change}
  end

  defp do_generate(coins, target, change)
  defp do_generate(_, 0, change), do: change
  defp do_generate([], _, _), do: []

  defp do_generate([hd | tl], target, change)
       when hd > target or has_too_many_small_coins(hd, target),
       do: do_generate(tl, target, change)

  defp do_generate([hd | tl] = coins, target, change) do
    new_target = target - hd
    new_change = [hd | change]

    [do_generate(coins, new_target, new_change), do_generate(tl, target, change)]
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.min_by(&Enum.count/1, fn -> [] end)
  end
end
