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

  def encode([]), do: <<>>
  def encode([head | tail]), do: <<encode_nucleotide(head)::@code_size, encode(tail)::bitstring>>

  def decode(<<>>), do: []
  def decode(<<head::@code_size, tail::bitstring>>), do: [decode_nucleotide(head) | decode(tail)]
end
