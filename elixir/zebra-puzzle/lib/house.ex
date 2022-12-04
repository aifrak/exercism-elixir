defmodule House do
  @type nationality :: :englishman | :spaniard | :ukrainian | :norwegian | :japanese
  @type color :: :red | :green | :ivory | :yellow | :blue
  @type cigarette :: :chesterfields | :kools | :lucky_strike | :parliaments | :old_gold
  @type drink :: :coffee | :tea | :milk | :orange_juice | :water
  @type pet :: :dog | :fox | :horse | :snails | :zebra

  @type t :: %__MODULE__{
          nationality: nationality | nil,
          color: :color | nil,
          location: :first | :next | :middle | :right | nil,
          neighbor: t() | nil,
          cigarette: cigarette | nil,
          drink: drink | nil,
          pet: pet | nil
        }
  defstruct [:nationality, :color, :location, :neighbor, :cigarette, :drink, :pet]

  @spec nationalities :: [nationality]
  def nationalities(), do: ~w(englishman spaniard ukrainian norwegian japanese)a

  @spec colors :: [color]
  def colors(), do: ~w(red green ivory yellow blue)a

  @spec cigarettes :: [cigarette]
  def cigarettes(), do: ~w(chesterfields kools lucky_strike parliaments old_gold)a

  @spec drinks :: [drink]
  def drinks(), do: ~w(coffee tea milk orange_juice water)a

  @spec pets :: [pet]
  def pets(), do: ~w(dog fox horse snails zebra)a
end
