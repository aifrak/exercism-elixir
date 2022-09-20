defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """

  @row_size 4
  @column_size 3
  @numbers_separator ","

  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    cond do
      invalid_row_size?(input) -> {:error, "invalid line count"}
      invalid_column_size?(input) -> {:error, "invalid column count"}
      true -> {:ok, do_convert(input)}
    end
  end

  defp invalid_row_size?(input), do: input |> length() |> rem(@row_size) != 0

  defp invalid_column_size?(input),
    do: Enum.any?(input, &(&1 |> String.length() |> rem(@column_size) != 0))

  defp do_convert(input) do
    input
    |> Enum.chunk_every(@row_size)
    |> Enum.map(&convert_row/1)
    |> Enum.join(@numbers_separator)
  end

  defp convert_row(lines) do
    lines
    |> Enum.map(&chunk_by_column(&1, []))
    |> Enum.zip_with(& &1)
    |> Enum.map(&convert_single/1)
  end

  defp chunk_by_column(<<>>, acc), do: Enum.reverse(acc)

  defp chunk_by_column(<<a, b, c, rest::bitstring>>, acc),
    do: chunk_by_column(rest, [<<a, b, c>> | acc])

  defp convert_single(input) do
    case input do
      [
        " _ ",
        "| |",
        "|_|",
        "   "
      ] ->
        "0"

      [
        "   ",
        "  |",
        "  |",
        "   "
      ] ->
        "1"

      [
        " _ ",
        " _|",
        "|_ ",
        "   "
      ] ->
        "2"

      [
        " _ ",
        " _|",
        " _|",
        "   "
      ] ->
        "3"

      [
        "   ",
        "|_|",
        "  |",
        "   "
      ] ->
        "4"

      [
        " _ ",
        "|_ ",
        " _|",
        "   "
      ] ->
        "5"

      [
        " _ ",
        "|_ ",
        "|_|",
        "   "
      ] ->
        "6"

      [
        " _ ",
        "  |",
        "  |",
        "   "
      ] ->
        "7"

      [
        " _ ",
        "|_|",
        "|_|",
        "   "
      ] ->
        "8"

      [
        " _ ",
        "|_|",
        " _|",
        "   "
      ] ->
        "9"

      _ ->
        "?"
    end
  end
end
