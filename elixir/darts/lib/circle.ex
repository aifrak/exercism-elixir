defmodule Circle do
  @enforce_keys [:radius, :point, :concentric]
  defstruct [:radius, :point, :concentric]

  def new(radius, point),
    do: %__MODULE__{
      radius: radius,
      point: point,
      concentric: to_concentric(radius)
    }

  defp to_concentric(radius), do: Integer.pow(radius, 2)
end
