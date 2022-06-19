defmodule RunLengthEncoder do
  @count_start 1

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    string
    |> open()
    |> IO.binstream(1)
    |> Stream.chunk_while([], &chunk_encode/2, &after_encode/1)
    |> Stream.flat_map(& &1)
    |> Stream.map(&encode_length/1)
    |> Enum.join()
  end

  defp encode_length({char, 1}), do: "#{char}"
  defp encode_length({char, count}), do: "#{count}#{char}"

  defp chunk_encode(char, [] = acc), do: {:cont, [{char, @count_start} | acc]}
  defp chunk_encode(char, [{char, count} | tail]), do: {:cont, [{char, count + 1} | tail]}
  defp chunk_encode(char, acc), do: {:cont, [{char, @count_start} | acc]}

  defp after_encode(acc), do: {:cont, Enum.reverse(acc), []}

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    string
    |> open()
    |> IO.binstream(1)
    |> Stream.chunk_while(%{curr_count: '', counts: []}, &chunk_decode/2, &after_decode/1)
    |> Stream.flat_map(& &1)
    |> Stream.map(&decode_length/1)
    |> Enum.join()
  end

  defp decode_length({char, count}), do: String.duplicate(char, count)

  defp chunk_decode(<<char>>, acc) when char in ?0..?9,
    do: {:cont, Map.update!(acc, :curr_count, &[char | &1])}

  defp chunk_decode(char, acc) do
    count = decode_count(acc.curr_count)
    acc = %{acc | counts: [{char, count} | acc.counts], curr_count: ''}
    {:cont, acc}
  end

  defp after_decode(acc), do: {:cont, Enum.reverse(acc.counts), []}

  defp decode_count(''), do: @count_start
  defp decode_count(curr_count), do: curr_count |> Enum.reverse() |> List.to_integer()

  defp open(str) do
    {:ok, pid} = StringIO.open(str)
    pid
  end
end
