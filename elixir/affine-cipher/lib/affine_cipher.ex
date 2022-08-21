defmodule AffineCipher do
  @alphabet Enum.to_list(?a..?z)
  @m length(@alphabet)

  @digits Enum.to_list(?0..?9)

  @encode_separator " "
  @group_size 5

  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a} = key, message) do
    if coprime?(a),
      do: convert(message, key, &encrypt/2),
      else: {:error, "a and m must be coprime."}
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a} = key, encrypted) do
    if coprime?(a),
      do: convert(encrypted, key, &decrypt/2),
      else: {:error, "a and m must be coprime."}
  end

  defp coprime?(a), do: Integer.gcd(a, @m) == 1

  defp encrypt(%{a: a, b: b}, i), do: (a * i + b) |> rem(@m)
  defp decrypt(%{a: a, b: b}, y), do: (mmi(a) * (y - b)) |> rem(@m)

  defp mmi(a), do: do_mmi(a, 1)

  defp do_mmi(a, x) when (a * x) |> rem(@m) == 1, do: x
  defp do_mmi(a, x), do: do_mmi(a, x + 1)

  defp convert(message, key, calc_fun) do
    message
    |> StringIO.open(fn pid ->
      pid
      |> IO.stream(1)
      |> Stream.filter(&String.match?(&1, ~r/[[:alpha:]]|\d/u))
      |> Stream.map(fn char -> convert_char(char, key, calc_fun) end)
      |> Stream.chunk_every(@group_size)
      |> Enum.join(if calc_fun == (&encrypt/2), do: @encode_separator, else: "")
    end)
  end

  defp convert_char(<<char>>, _, _) when char in @digits, do: char

  defp convert_char(char, key, calc_fun) do
    char
    |> String.downcase()
    |> then(&Enum.find_index(@alphabet, fn letter -> <<letter>> == &1 end))
    |> then(&calc_fun.(key, &1))
    |> then(&Enum.at(@alphabet, &1))
    |> then(&<<&1>>)
  end
end
