defmodule TwoBucket.Bucket do
  defstruct [:size, :liters]
  @type t :: %__MODULE__{size: integer, liters: integer}

  @spec new(integer) :: t()
  def new(size), do: %__MODULE__{size: size, liters: 0}

  @spec transfer(t(), t()) :: {t(), t()}
  def transfer(a, b) do
    transferred = min(a.liters, b.size - b.liters)
    a = %{a | liters: a.liters - transferred}
    b = %{b | liters: b.liters + transferred}
    {a, b}
  end

  @spec empty(t()) :: t()
  def empty(bucket), do: %{bucket | liters: 0}

  @spec fill(t()) :: t()
  def fill(bucket), do: %{bucket | liters: bucket.size}
end
