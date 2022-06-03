defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  # Add code to define the protocol and its implementations below here...
  defprotocol Edible do
    def eat(item, character)
  end

  defimpl Edible, for: RPG.LoafOfBread do
    @health_regen 5

    def eat(_item, %Character{} = character) do
      character
      |> Map.update!(:health, &(&1 + @health_regen))
      |> then(&{nil, &1})
    end
  end

  defimpl Edible, for: RPG.ManaPotion do
    def eat(%ManaPotion{} = item, %Character{} = character) do
      character
      |> Map.update!(:mana, &(&1 + item.strength))
      |> then(&{%EmptyBottle{}, &1})
    end
  end

  defimpl Edible, for: RPG.Poison do
    def eat(_item, %Character{} = character) do
      character
      |> struct(health: 0)
      |> then(&{%EmptyBottle{}, &1})
    end
  end
end
