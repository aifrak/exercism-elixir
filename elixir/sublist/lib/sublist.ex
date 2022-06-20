defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare([], []), do: :equal
  def compare(_, []), do: :superlist
  def compare([], _), do: :sublist
  def compare(a, a), do: :equal

  def compare(a, b) when length(a) < length(b),
    do: if(sublist?(a, b), do: :sublist, else: :unequal)

  def compare(a, b), do: if(sublist?(b, a), do: :superlist, else: :unequal)

  defp sublist?(a, b), do: a in Enum.chunk_every(b, length(a), 1, :discard)
end
