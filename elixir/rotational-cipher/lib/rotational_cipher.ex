defmodule RotationalCipher do
  @alphabet_length 26

  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    key = Kernel.rem(shift, 26)

    text
    |> String.to_charlist()
    |> Enum.map(&rotate_char(&1, key))
    |> List.to_string()
  end

  @spec rotate_char(char :: char, key :: integer) :: char
  defp rotate_char(char, key) when char >= ?a and char <= ?z, do: fix_char(char + key, ?z)
  defp rotate_char(char, key) when char >= ?A and char <= ?Z, do: fix_char(char + key, ?Z)
  defp rotate_char(char, _key), do: char

  @spec fix_char(char :: integer, limit :: integer) :: char
  defp fix_char(char, limit) when char > limit, do: char - @alphabet_length
  defp fix_char(char, _limit), do: char
end
