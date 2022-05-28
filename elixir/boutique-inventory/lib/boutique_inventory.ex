defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: Enum.sort_by(inventory, & &1.price)

  def with_missing_price(inventory), do: Enum.filter(inventory, &(&1.price == nil))

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item ->
      item.name
      |> String.replace(old_word, new_word)
      |> (&%{item | name: &1}).()
    end)
  end

  def increase_quantity(item, count) do
    item.quantity_by_size
    |> Map.new(fn {size, quantity} -> {size, quantity + count} end)
    |> (&%{item | quantity_by_size: &1}).()
  end

  def total_quantity(item) do
    item.quantity_by_size
    |> Enum.reduce(0, fn {_, quantity}, total -> total + quantity end)
  end
end
