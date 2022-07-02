defmodule PascalsTriangle do
  @offset 1
  @first_number 1
  @first_list [1]

  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num), do: do_rows([@first_list], num - @offset) |> Enum.reverse()

  defp do_rows(acc, 0), do: acc

  defp do_rows([head | _] = acc, num) do
    head
    |> Enum.chunk_every(2, 1)
    |> Enum.map(&Enum.sum/1)
    |> then(&[@first_number | &1])
    |> then(&do_rows([&1 | acc], num - 1))
  end
end
