defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    numbers = Integer.digits(number)
    exponent = length(numbers)

    Enum.reduce(numbers, 0, &(Integer.pow(&1, exponent) + &2)) == number
  end
end
