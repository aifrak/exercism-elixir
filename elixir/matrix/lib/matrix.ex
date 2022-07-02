defmodule Matrix do
  @row_separator "\n"
  @col_separator " "
  @offset 1

  defstruct matrix: nil

  defp new(lists), do: %__MODULE__{matrix: lists}

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    input
    |> String.split(@row_separator)
    |> Stream.map(&String.split(&1, @col_separator))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
    |> then(&new/1)
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix),
    do: Enum.map_join(matrix.matrix, @row_separator, &Enum.join(&1, @col_separator))

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix), do: matrix.matrix

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index), do: Enum.at(matrix.matrix, index - @offset)

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix), do: Enum.zip_with(matrix.matrix, & &1)

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index), do: Enum.at(columns(matrix), index - @offset)
end
