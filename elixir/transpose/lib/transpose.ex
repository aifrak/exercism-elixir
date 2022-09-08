defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @pad "\t"

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    list = String.split(input, "\n")
    padding = padding(list)

    list
    |> Enum.map(&string_to_row(&1, padding))
    |> Enum.zip_with(& &1)
    |> Enum.map_join("\n", &row_to_string/1)
  end

  defp padding(list), do: list |> Enum.max_by(&String.length/1) |> String.length()

  defp string_to_row(string, padding),
    do: string |> String.pad_trailing(padding, @pad) |> String.graphemes()

  defp row_to_string(row),
    do: row |> Enum.join() |> String.trim_trailing(@pad) |> String.replace(@pad, " ")
end
