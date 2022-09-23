defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode("", _), do: ""
  def encode(str, 1), do: str

  def encode(str, rails) do
    str_rails = List.duplicate("", rails)

    str
    |> String.graphemes()
    |> Enum.zip(zig_zag_rail_indices(rails))
    |> Enum.reduce(str_rails, fn {char, rail_index}, acc ->
      update_in(acc, [Access.at(rail_index)], &(char <> &1))
    end)
    |> Enum.map_join(&String.reverse/1)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode("", _), do: ""
  def decode(str, 1), do: str

  def decode(str, rails) do
    str
    |> decode_char_indices(rails)
    |> Enum.zip(String.graphemes(str))
    |> Enum.sort()
    |> Enum.map_join("", fn {_, char} -> char end)
  end

  defp decode_char_indices(str, rails) do
    list_rails = List.duplicate([], rails)

    rails
    |> zig_zag_rail_indices()
    |> Enum.take(String.length(str))
    |> Enum.with_index()
    |> Enum.reduce(list_rails, fn {rail_index, str_index}, acc ->
      update_in(acc, [Access.at(rail_index)], &[str_index | &1])
    end)
    |> Enum.reduce([], &++/2)
    |> Enum.reverse()
  end

  defp zig_zag_rail_indices(rails) do
    list = 0..(rails - 1)

    list
    |> Stream.concat(Enum.reverse(list))
    |> Stream.cycle()
    |> Stream.dedup()
  end
end
