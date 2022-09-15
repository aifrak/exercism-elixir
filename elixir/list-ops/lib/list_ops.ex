defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)

  defp do_count([], count), do: count
  defp do_count([_ | tl], count), do: do_count(tl, count + 1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])

  defp do_reverse([], reversed), do: reversed
  defp do_reverse([hd | tl], reversed), do: do_reverse(tl, [hd | reversed])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f, [])

  defp do_map([], _, l2), do: reverse(l2)
  defp do_map([hd | tl], f, l2), do: do_map(tl, f, [f.(hd) | l2])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f, [])

  defp do_filter([], _, l2), do: reverse(l2)

  defp do_filter([hd | tl], f, l2) do
    if f.(hd),
      do: do_filter(tl, f, [hd | l2]),
      else: do_filter(tl, f, l2)
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _), do: acc
  def foldl([hd | tl], acc, f), do: foldl(tl, f.(hd, acc), f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f), do: l |> reverse() |> do_foldr(acc, f)

  defp do_foldr([], acc, _), do: acc
  defp do_foldr([hd | tl], acc, f), do: do_foldr(tl, f.(hd, acc), f)

  @spec append(list, list) :: list
  def append(a, []), do: a
  def append([], b), do: b
  def append(a, b), do: a |> reverse() |> do_append(b)

  defp do_append([], b), do: b
  defp do_append([hd | tl], b), do: do_append(tl, [hd | b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: foldr(ll, [], &append/2)
end
