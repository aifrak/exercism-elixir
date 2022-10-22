defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true
  def chain?([{a, a}]), do: true

  def chain?(dominoes), do: do_chain?(dominoes, MapSet.new(), [])

  defp do_chain?([{h1, h2}], halves, _),
    do: if(h1 in halves and h2 in halves, do: true, else: false)

  defp do_chain?([{h1, h2} = h | t] = all, halves, solos) do
    cond do
      Enum.empty?(halves) or h1 in halves or h2 in halves ->
        do_chain?(t, MapSet.union(halves, MapSet.new([h1, h2])), List.delete(solos, h))

      Enum.sort(all) == Enum.sort(solos) ->
        false

      true ->
        do_chain?(t ++ [h], halves, may_add_to_solos(h, solos))
    end
  end

  defp may_add_to_solos(domino, solos), do: if(domino in solos, do: solos, else: [domino | solos])
end
