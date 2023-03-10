defmodule DNA do
  @code_size 4

  @acids %{
    ?\s => 0b0000,
    ?A => 0b0001,
    ?C => 0b0010,
    ?G => 0b0100,
    ?T => 0b1000
  }

  @codes Map.new(@acids, fn {key, val} -> {val, key} end)

  def encode_nucleotide(code_point), do: @acids[code_point]

  def decode_nucleotide(encoded_code), do: @codes[encoded_code]

  def encode(dna), do: do_encode(dna)

  defp do_encode(dna, acc \\ <<>>)
  defp do_encode([], acc), do: acc

  defp do_encode([h | t], acc),
    do: do_encode(t, <<acc::bits, encode_nucleotide(h)::@code_size>>)

  def decode(dna), do: do_decode(dna)

  defp do_decode(dna, acc \\ [])
  defp do_decode(<<>>, acc), do: reverse(acc)
  defp do_decode(<<h::@code_size, t::bits>>, acc), do: do_decode(t, [decode_nucleotide(h) | acc])

  defp reverse(dna, acc \\ [])
  defp reverse([], acc), do: acc
  defp reverse([h | t], acc), do: reverse(t, [h | acc])
end
