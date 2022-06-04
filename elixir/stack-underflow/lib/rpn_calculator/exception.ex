defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception([]), do: %__MODULE__{}

    def exception(context) do
      message = "stack underflow occurred, context: #{context}"
      %__MODULE__{message: message}
    end
  end

  def divide([0, _]), do: raise(DivisionByZeroError)

  def divide(list) when is_list(list) and length(list) < 2 do
    raise StackUnderflowError, "when dividing"
  end

  def divide([divisor, dividend]), do: dividend / divisor
end
