defmodule Grep.Line do
  @enforce_keys [:number, :text]
  defstruct [:number, :text]

  @type t :: %__MODULE__{number: pos_integer(), text: String.t()}

  @spec new(number(), String.t()) :: %Grep.Line{}
  def new(number, text), do: %__MODULE__{number: number, text: text}
end
