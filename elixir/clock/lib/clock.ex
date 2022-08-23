defmodule Clock do
  defstruct hour: 0, minute: 0

  @type t :: %__MODULE__{hour: integer, minute: integer}

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock.t()
  def new(hour, minute) do
    m_clock = to_clock(minute)

    %__MODULE__{hour: Integer.mod(hour + m_clock.hour, 24), minute: m_clock.minute}
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock.t(), integer()) :: Clock.t()
  def add(%Clock{hour: hour, minute: minute}, add_minute), do: new(hour, minute + add_minute)

  defp to_clock(minute),
    do: %__MODULE__{hour: Integer.floor_div(minute, 60), minute: Integer.mod(minute, 60)}
end

defimpl String.Chars, for: Clock do
  @spec to_string(Clock.t()) :: String.t()
  def to_string(%Clock{hour: hour, minute: minute}), do: "#{print(hour)}:#{print(minute)}"

  defp print(number), do: number |> Integer.to_string() |> String.pad_leading(2, "0")
end
