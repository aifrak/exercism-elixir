defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers), do: integers |> Enum.map(&do_encode/1) |> Enum.join()

  defp do_encode(integer), do: encode_binary(<<integer::7*5>>)

  defp encode_binary(decoded, encoded \\ <<>>, sign_bit \\ 0)
  defp encode_binary(<<group::7>>, encoded, _), do: <<encoded::bits, 0::1, group::7>>

  defp encode_binary(<<group::7, rest::bits>>, encoded, sign_bit)
       when sign_bit == 1 or group > 0,
       do: encode_binary(rest, <<encoded::bits, 1::1, group::7>>, 1)

  defp encode_binary(<<_::7, rest::bits>>, _, _), do: encode_binary(rest)

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: do_decode(bytes)

  defp do_decode(encoded, decoded \\ [], to_decode \\ <<>>)
  defp do_decode(<<>>, decoded, <<>>), do: {:ok, Enum.reverse(decoded)}
  defp do_decode(<<>>, _, _), do: {:error, "incomplete sequence"}

  defp do_decode(<<0::1, group::7, rest::bits>>, decoded, to_decode),
    do: do_decode(rest, [to_integer(<<to_decode::bits, group::7>>) | decoded], <<>>)

  defp do_decode(<<1::1, group::7, rest::bits>>, decoded, to_decode),
    do: do_decode(rest, decoded, <<to_decode::bits, group::7>>)

  defp to_integer(to_decode) do
    <<integer::size(bit_size(to_decode))>> = to_decode
    integer
  end
end
