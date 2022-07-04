defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite(strings) do
    strings
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map_join("", fn [s1, s2] -> "For want of a #{s1} the #{s2} was lost.\n" end)
    |> Kernel.<>("And all for the want of a #{List.first(strings)}.\n")
  end
end
