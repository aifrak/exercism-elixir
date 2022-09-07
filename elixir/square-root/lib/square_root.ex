defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) do
    Enum.reduce_while(1..radicand, 0, fn num, acc ->
      if num * num == radicand, do: {:halt, num}, else: {:cont, acc}
    end)
  end
end
