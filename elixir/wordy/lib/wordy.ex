defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(words), do: words |> String.trim_trailing("?") |> String.split() |> do_answer()

  defp do_answer(words, total \\ 0)
  defp do_answer([], total), do: total
  defp do_answer([n], 0), do: to_number(n)
  defp do_answer(["What", "is" | rest], total), do: do_answer(rest, total)

  defp do_answer([n1, op, "by", n2 | rest], 0) when op in ["multiplied", "divided"],
    do: do_answer(rest, calculate(n1, "#{op} by", n2))

  defp do_answer([n1, op, n2 | rest], 0), do: do_answer(rest, calculate(n1, op, n2))

  defp do_answer([op, "by", n2 | rest], total) when op in ["multiplied", "divided"],
    do: do_answer(rest, calculate(total, "#{op} by", n2))

  defp do_answer([op, n2 | rest], total), do: do_answer(rest, calculate(total, op, n2))
  defp do_answer(_, _), do: raise(ArgumentError)

  defp calculate(n1, op, n2), do: operation(op).(to_number(n1), to_number(n2))

  defp operation("plus"), do: &+/2
  defp operation("minus"), do: &-/2
  defp operation("multiplied by"), do: &*/2
  defp operation("divided by"), do: &//2
  defp operation(_), do: raise(ArgumentError)

  defp to_number(n) when is_binary(n), do: String.to_integer(n)
  defp to_number(n), do: n
end
