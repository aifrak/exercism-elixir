defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """

  import Bitwise

  @code_wink 0b1
  @code_double_blink 0b10
  @code_close_eyes 0b100
  @code_jump 0b1000
  @code_reverse 0b10000

  @codes [
    @code_wink,
    @code_double_blink,
    @code_close_eyes,
    @code_jump,
    @code_reverse
  ]

  defmacro is_bit_on(left, right) do
    quote do: (unquote(left) &&& unquote(right)) > 0
  end

  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    @codes
    |> Enum.filter(&is_bit_on(code, &1))
    |> Enum.reduce([], &apply_secret(&1, &2))
  end

  defp apply_secret(code, list) when is_bit_on(code, @code_wink) do
    Enum.concat(list, ["wink"])
  end

  defp apply_secret(code, list) when is_bit_on(code, @code_double_blink) do
    Enum.concat(list, ["double blink"])
  end

  defp apply_secret(code, list) when is_bit_on(code, @code_close_eyes) do
    Enum.concat(list, ["close your eyes"])
  end

  defp apply_secret(code, list) when is_bit_on(code, @code_jump) do
    Enum.concat(list, ["jump"])
  end

  defp apply_secret(code, list) when is_bit_on(code, @code_reverse) do
    Enum.reverse(list)
  end
end
