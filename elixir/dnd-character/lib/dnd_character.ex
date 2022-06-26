defmodule DndCharacter do
  @dice_sides 1..6

  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score), do: floor((score - 10) / 2)

  @spec ability :: pos_integer()
  def ability do
    @dice_sides
    |> Enum.take_random(4)
    |> drop_lowest()
    |> Enum.sum()
  end

  @spec character :: t()
  def character do
    character = %__MODULE__{
      strength: ability(),
      dexterity: ability(),
      constitution: ability(),
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability()
    }

    %{character | hitpoints: hitpoints(character.constitution)}
  end

  defp drop_lowest(throws), do: throws |> Enum.sort() |> Enum.drop(1)
  defp hitpoints(constitution), do: 10 + modifier(constitution)
end
