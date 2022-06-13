defmodule Circle do
  @enforce_keys [:radius, :score]
  defstruct [:radius, :score]

  def new(radius, score),
    do: %__MODULE__{
      radius: radius,
      score: score
    }
end
