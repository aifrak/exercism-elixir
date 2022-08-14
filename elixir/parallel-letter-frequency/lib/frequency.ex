defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(&frequency/1, max_concurrency: workers)
    |> Enum.reduce(%{}, fn {:ok, frequencies}, acc -> sum_frequencies(frequencies, acc) end)
  end

  defp frequency(text) do
    text
    |> StringIO.open(fn pid ->
      pid
      |> IO.stream(1)
      |> Stream.map(&String.downcase/1)
      |> Stream.filter(&letter?/1)
      |> Enum.frequencies()
    end)
    |> elem(1)
  end

  defp sum_frequencies(f1, f2), do: Map.merge(f1, f2, fn _, v1, v2 -> v1 + v2 end)

  defp letter?(downcase), do: downcase != String.upcase(downcase)
end
