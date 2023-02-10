defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""

  def encode(str) do
    message = normalize(str)
    message |> columns_number() |> then(&do_encode(message, &1))
  end

  defp do_encode(_, 0), do: ""

  defp do_encode(message, cols_nb) do
    message
    |> String.graphemes()
    |> Enum.chunk_every(cols_nb)
    |> Enum.map(&pad_trailing(&1, cols_nb, " "))
    |> Enum.zip_with(& &1)
    |> Enum.join(" ")
  end

  defp normalize(str), do: str |> String.replace(~r/[^[:alnum:]]/, "") |> String.downcase()

  defp columns_number(message) do
    message_length = String.length(message)

    message_length
    |> :math.sqrt()
    |> round()
    |> may_adjust_columns_number(message_length)
  end

  defp may_adjust_columns_number(cols_nb, message_length),
    do: if(cols_nb * cols_nb >= message_length, do: cols_nb, else: cols_nb + 1)

  defp pad_trailing(list, cols_nb, padding), do: pad(list, cols_nb, padding, 0, [])

  defp pad(_, cols_nb, _, cols_nb, acc), do: Enum.reverse(acc)

  defp pad([], cols_nb, padding, count, acc),
    do: pad([], cols_nb, padding, count + 1, [padding | acc])

  defp pad([h | t], cols_nb, padding, count, acc),
    do: pad(t, cols_nb, padding, count + 1, [h | acc])
end
