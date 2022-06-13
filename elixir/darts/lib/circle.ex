defmodule Circle do
  @enforce_keys [:radius, :points]
  defstruct [:radius, :points]

  def new(radius, points),
    do: %__MODULE__{
      radius: radius,
      points: points
    }
end
