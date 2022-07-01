defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str), do: check(str, [])

  defp check(<<>>, []), do: true
  defp check(<<>>, _), do: false
  defp check(<<c, _::binary>>, []) when c in ')]}', do: false
  defp check(<<?), _::binary>>, [last_open | _]) when last_open != ?(, do: false
  defp check(<<?], _::binary>>, [last_open | _]) when last_open != ?[, do: false
  defp check(<<?}, _::binary>>, [last_open | _]) when last_open != ?{, do: false
  defp check(<<c, rest::binary>>, brackets) when c in '([{', do: check(rest, [c | brackets])
  defp check(<<c, rest::binary>>, [_ | tail]) when c in ')]}', do: check(rest, tail)
  defp check(<<_, rest::binary>>, brackets), do: check(rest, brackets)
end
