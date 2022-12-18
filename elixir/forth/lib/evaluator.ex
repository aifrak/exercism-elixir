defmodule Evaluator do
  @type stack :: [integer()]
  @type operation :: (stack -> {:ok, stack} | {:error, atom()})
  @type definitions :: %{String.t() => [operation]}

  @type t :: %__MODULE__{definitions: definitions, stack: stack}
  defstruct definitions: %{
              "+" => [&__MODULE__.add/1],
              "-" => [&__MODULE__.subtract/1],
              "*" => [&__MODULE__.multiply/1],
              "/" => [&__MODULE__.divide/1],
              "DUP" => [&__MODULE__.duplicate/1],
              "DROP" => [&__MODULE__.drop/1],
              "SWAP" => [&__MODULE__.swap/1],
              "OVER" => [&__MODULE__.over/1]
            },
            stack: []

  @spec add(stack) :: {:ok, stack} | {:error, :stack_underflow}
  def add([h1, h2 | t]), do: {:ok, [h2 + h1 | t]}
  def add(_), do: {:error, :stack_underflow}

  @spec subtract(stack) :: {:ok, stack} | {:error, :stack_underflow}
  def subtract([h1, h2 | t]), do: {:ok, [h2 - h1 | t]}
  def subtract(_), do: {:error, :stack_underflow}

  @spec multiply(stack) :: {:ok, stack} | {:error, :stack_underflow}
  def multiply([h1, h2 | t]), do: {:ok, [h2 * h1 | t]}
  def multiply(_), do: {:error, :stack_underflow}

  @spec divide(stack) :: {:ok, stack} | {:error, :stack_underflow | :division_by_zero}
  def divide([0, _ | _]), do: {:error, :division_by_zero}
  def divide([h1, h2 | t]), do: {:ok, [div(h2, h1) | t]}
  def divide(_), do: {:error, :stack_underflow}

  @spec duplicate(stack) :: {:ok, stack} | {:error, :stack_underflow}
  def duplicate([h | t]), do: {:ok, [h, h | t]}
  def duplicate(_), do: {:error, :stack_underflow}

  @spec drop(stack) :: {:ok, stack} | {:error, :stack_underflow}
  def drop([_ | t]), do: {:ok, t}
  def drop(_), do: {:error, :stack_underflow}

  @spec swap(stack) :: {:ok, stack} | {:error, :stack_underflow}
  def swap([h1, h2 | t]), do: {:ok, [h2, h1 | t]}
  def swap(_), do: {:error, :stack_underflow}

  @spec over(stack) :: {:ok, stack} | {:error, :stack_underflow}
  def over([h1, h2 | t]), do: {:ok, [h2, h1, h2 | t]}
  def over(_), do: {:error, :stack_underflow}

  @spec add_stack_as_operation(stack) :: [operation]
  def add_stack_as_operation(old_stack),
    do: [fn new_stack -> {:ok, new_stack |> Kernel.++(old_stack) |> Enum.reverse()} end]

  @spec tokens_to_operations([String.t()], t()) :: stack
  def tokens_to_operations(tokens, ev),
    do: Enum.reduce(tokens, [], &(ev.definitions[to_word(&1)] ++ &2)) |> Enum.reverse()

  @spec to_word(String.t()) :: String.t()
  def to_word(str), do: String.upcase(str)
end
