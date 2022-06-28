defmodule Verse do
  @enforce_keys [:action, :object]
  defstruct [:action, :object]

  def new(action, object), do: %__MODULE__{action: action, object: object}
end
