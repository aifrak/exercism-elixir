defmodule Grains do
  @first_square 1
  @last_square 64

  defguardp is_in_squares(number) when number >= @first_square and number <= @last_square

  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer()) :: {:ok, pos_integer()} | {:error, String.t()}
  def square(number) when is_in_squares(number), do: {:ok, do_square(number)}
  def square(_), do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer()}
  def total do
    total =
      @first_square..@last_square
      |> Stream.map(&do_square/1)
      |> Enum.sum()

    {:ok, total}
  end

  defp do_square(number), do: Integer.pow(2, number - 1)
end
