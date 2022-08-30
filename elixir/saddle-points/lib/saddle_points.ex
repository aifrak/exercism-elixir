defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str),
    do: str |> StringIO.open(fn pid -> pid |> IO.stream(:line) |> Enum.map(&row/1) end) |> elem(1)

  defp row(str), do: String.split(str) |> Enum.map(&String.to_integer/1)

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str), do: str |> rows() |> transpose()

  defp transpose(matrix), do: Enum.zip_with(matrix, & &1)

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    row_maxs = str |> rows() |> Enum.map(&Enum.max/1) |> Enum.with_index(1)
    col_mins = str |> columns() |> Enum.map(&Enum.min/1) |> Enum.with_index(1)

    for {min, row} <- row_maxs, {max, col} <- col_mins, min == max, do: {row, col}
  end
end
