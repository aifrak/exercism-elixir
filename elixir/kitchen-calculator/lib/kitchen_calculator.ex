defmodule KitchenCalculator do
  @cup_in_ml 240
  @fluid_ounce_in_ml 30
  @teaspoon_in_ml 5
  @tablespoon_in_ml 15

  def get_volume({_, volume}), do: volume

  def to_milliliter({unit, volume} = volume_pair) do
    case unit do
      :milliliter -> volume_pair
      :cup -> {:milliliter, volume * @cup_in_ml}
      :fluid_ounce -> {:milliliter, volume * @fluid_ounce_in_ml}
      :teaspoon -> {:milliliter, volume * @teaspoon_in_ml}
      :tablespoon -> {:milliliter, volume * @tablespoon_in_ml}
    end
  end

  def from_milliliter(volume_pair, unit) do
    volume = get_volume(volume_pair)

    case unit do
      :milliliter -> volume_pair
      :cup -> {unit, volume / @cup_in_ml}
      :fluid_ounce -> {unit, volume / @fluid_ounce_in_ml}
      :teaspoon -> {unit, volume / @teaspoon_in_ml}
      :tablespoon -> {unit, volume / @tablespoon_in_ml}
    end
  end

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(unit)
  end
end
