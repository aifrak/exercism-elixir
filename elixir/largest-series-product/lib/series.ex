defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_, 0), do: 1

  def largest_product(number_string, size) do
    with :ok <- validate_size(size),
         :ok <- validate_lengths(number_string, size) do
      number_string
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(size, 1, :discard)
      |> Enum.map(&(Enum.dedup(&1) |> Enum.product()))
      |> Enum.max()
    end
  end

  defp validate_size(size) do
    if size >= 0, do: :ok, else: raise(ArgumentError, "Span size must be positive")
  end

  defp validate_lengths(number_string, size) do
    if String.length(number_string) >= size,
      do: :ok,
      else: raise(ArgumentError, "Number of digits must be less than or equal to span size")
  end
end
