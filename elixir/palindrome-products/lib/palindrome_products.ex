defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)
  def generate(max_factor, min_factor) when max_factor < min_factor, do: raise(ArgumentError)
  def generate(max_factor, max_factor), do: %{}

  def generate(max_factor, min_factor) do
    min_factor..max_factor
    |> palindromes()
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> {k, MapSet.to_list(v)} end)
    |> Map.new()
  end

  defp palindromes(factors_range) do
    for x <- factors_range,
        y <- factors_range,
        x <= y,
        product = x * y,
        palindrome?(product),
        reduce: %{} do
      acc -> add_palindrome(product, Enum.sort([x, y]), acc)
    end
  end

  defp palindrome?(product), do: Integer.digits(product) |> then(&(&1 == Enum.reverse(&1)))

  defp add_palindrome(product, factors, acc),
    do: Map.update(acc, product, MapSet.new([factors]), &MapSet.put(&1, factors))
end
