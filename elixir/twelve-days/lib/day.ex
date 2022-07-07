defmodule Day do
  @enforce_keys [:nth, :gift]
  defstruct [:nth, :gift]

  def new(nth, gift), do: %__MODULE__{nth: nth, gift: gift}

  def append_and(day), do: Day.new(day.nth, "and #{day.gift}")
end
