defmodule SimpleCipher do
  @alphabet Enum.to_list(?a..?z)
  @alphabet_length length(@alphabet)

  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key), do: do_encode(plaintext, key, [])

  defp do_encode(<<>>, _, acc), do: Enum.reverse(acc) |> to_string()

  defp do_encode(<<char, r1::binary>>, <<key_char, r2::binary>>, acc) do
    char
    |> encode_char(key_char)
    |> then(&do_encode(r1, r2 <> <<key_char>>, [&1 | acc]))
  end

  defp encode_char(char, key_char), do: Enum.at(@alphabet, shift(index(char), index(key_char)))
  defp shift(index, offset), do: rem(index + offset, @alphabet_length)

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key), do: do_decode(ciphertext, key, [])

  defp do_decode(<<>>, _, acc), do: Enum.reverse(acc) |> to_string()

  defp do_decode(<<char, r1::binary>>, <<key_char, r2::binary>>, acc) do
    char
    |> decode_char(key_char)
    |> then(&do_decode(r1, r2 <> <<key_char>>, [&1 | acc]))
  end

  defp decode_char(char, key_char), do: Enum.at(@alphabet, unshift(index(char), index(key_char)))
  defp unshift(index, offset), do: rem(index - offset, @alphabet_length)

  @doc """
  Generate a random key of a given length. It should contain lowercase letters only.
  """
  def generate_key(length) do
    fn -> Enum.random(@alphabet) end
    |> Stream.repeatedly()
    |> Enum.take(length)
    |> to_string()
  end

  defp index(char), do: Enum.find_index(@alphabet, &(&1 == char))
end
