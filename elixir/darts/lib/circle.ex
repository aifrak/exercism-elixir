defmodule Circle do
  @enforce_keys [:radius, :point]
  defstruct [:radius, :point]

  def new(radius, point),
    do: %__MODULE__{
      radius: radius,
      point: point
    }
end
