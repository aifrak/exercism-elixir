defmodule Atbash do
  @plain Enum.map(?a..?z, &<<&1>>)
  @cipher Enum.reverse(@plain)
  @digits Enum.map(?0..?9, &<<&1>>)

  @atbash Enum.zip(@plain, @cipher) |> Map.new()

  @cipher_separator " "
  @group_size 5

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> StringIO.open(fn pid ->
      pid
      |> IO.binstream(1)
      |> Stream.map(&String.downcase/1)
      |> Stream.map(&convert/1)
      |> Stream.reject(&(&1 == nil))
      |> Stream.chunk_every(@group_size)
      |> Enum.join(@cipher_separator)
    end)
    |> elem(1)
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> StringIO.open(fn pid ->
      pid
      |> IO.binstream(1)
      |> Stream.map(&convert/1)
      |> Stream.reject(&(&1 == nil))
      |> Enum.join()
    end)
    |> elem(1)
  end

  defp convert(char) do
    cond do
      char in @digits -> char
      char in @plain -> @atbash[char]
      true -> nil
    end
  end
end
