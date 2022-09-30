defmodule VariableLengthQuantity do
  @bit_on 1
  @bit_off 0

  @sign_bit_on <<@bit_on::1>>
  @sign_bit_off <<@bit_off::1>>

  @group_size 7

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers), do: integers |> Enum.map(&do_encode/1) |> Enum.join()

  defp do_encode(integer), do: encode_binary(<<integer::@group_size*5>>)

  defp encode_binary(decoded, encoded \\ <<>>, sign_bit \\ @bit_off)

  defp encode_binary(<<group::@group_size>>, encoded, _),
    do: <<encoded::bits, @sign_bit_off, group::@group_size>>

  defp encode_binary(<<group::@group_size, rest::bits>>, encoded, sign_bit)
       when sign_bit == @bit_on or group > 0,
       do: encode_binary(rest, <<encoded::bits, @sign_bit_on, group::@group_size>>, @bit_on)

  defp encode_binary(<<_::@group_size, rest::bits>>, _, _), do: encode_binary(rest)

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: do_decode(bytes)

  defp do_decode(encoded, decoded \\ [], to_decode \\ <<>>)
  defp do_decode(<<>>, decoded, <<>>), do: {:ok, Enum.reverse(decoded)}
  defp do_decode(<<>>, _, _), do: {:error, "incomplete sequence"}

  defp do_decode(<<@sign_bit_off, group::@group_size, rest::bits>>, decoded, to_decode),
    do: do_decode(rest, [to_integer(<<to_decode::bits, group::@group_size>>) | decoded], <<>>)

  defp do_decode(<<@sign_bit_on, group::@group_size, rest::bits>>, decoded, to_decode),
    do: do_decode(rest, decoded, <<to_decode::bits, group::@group_size>>)

  defp to_integer(to_decode) do
    <<integer::size(bit_size(to_decode))>> = to_decode
    integer
  end
end
