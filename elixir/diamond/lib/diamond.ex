defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    letter
    |> triangle()
    |> mirror_down()
    |> mirror_left()
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp triangle(letter), do: Enum.reduce(letter..?A, [], &[line(&1, letter) | &2])

  defp line(letter, target_letter), do: Enum.map(?A..target_letter, &char(&1, letter))

  defp char(letter, letter), do: <<letter>>
  defp char(_, _), do: " "

  defp mirror_left(matrix), do: Enum.map(matrix, &(flip_left(&1) ++ &1))
  defp mirror_down(matrix), do: matrix ++ flip_down(matrix)

  defp flip_left(matrix), do: Enum.drop(matrix, 1) |> Enum.reverse()
  defp flip_down(matrix), do: Enum.reverse(matrix) |> Enum.drop(1)
end
