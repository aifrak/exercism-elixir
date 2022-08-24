defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}
  defstruct map: %{}

  @spec new(Enum.t()) :: t
  def new(enumerable), do: Enum.reduce(enumerable, %{}, &Map.put_new(&2, &1, nil)) |> to_struct()

  @spec empty?(t) :: boolean
  def empty?(%{map: map}), do: map == %{}

  @spec contains?(t, any) :: boolean
  def contains?(%{map: map}, element), do: Map.has_key?(map, element)

  @spec subset?(t, t) :: boolean
  def subset?(%{map: map_1}, %{map: map_2}), do: same_keys(map_1, map_2) == map_1

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%{map: map_1}, %{map: map_2}), do: diff_keys(map_1, map_2) == map_1

  @spec equal?(t, t) :: boolean
  def equal?(%{map: map_1}, %{map: map_2}), do: map_1 == map_2

  @spec add(t, any) :: t
  def add(custom_set, element), do: Map.update!(custom_set, :map, &Map.put_new(&1, element, nil))

  @spec intersection(t, t) :: t
  def intersection(%{map: map_1}, %{map: map_2}), do: same_keys(map_1, map_2) |> to_struct()

  @spec difference(t, t) :: t
  def difference(%{map: map_1}, %{map: map_2}), do: diff_keys(map_1, map_2) |> to_struct()

  @spec union(t, t) :: t
  def union(%{map: map_1}, %{map: map_2}), do: Map.merge(map_1, map_2) |> to_struct()

  defp to_struct(map), do: %__MODULE__{map: map}

  defp diff_keys(map_1, map_2), do: Map.drop(map_1, Map.keys(map_2))

  defp same_keys(map_1, map_2), do: Map.take(map_1, Map.keys(map_2))
end
