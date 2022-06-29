defmodule IsbnVerifier do
  @length 10
  @separator "-"

  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn = String.replace(isbn, @separator, "")

    if valid_format?(isbn) do
      isbn
      |> checksum()
      |> valid_checksum?()
    else
      false
    end
  end

  defp checksum(isbn) do
    isbn
    |> String.to_charlist()
    |> Stream.map(&char_to_value/1)
    |> Stream.transform(@length, &{[&1 * &2], &2 - 1})
    |> Enum.sum()
  end

  defp valid_checksum?(checksum), do: rem(checksum, 11) == 0
  defp valid_format?(isbn), do: String.length(isbn) == @length && all_valid_chars?(isbn)

  defp all_valid_chars?(isbn), do: not any_invalid_chars?(isbn)
  defp any_invalid_chars?(isbn), do: Regex.match?(~r/[^0-9X]/, isbn)

  defp char_to_value(char) when char in ?0..?9, do: String.to_integer(<<char>>)
  defp char_to_value(?X), do: 10
end
