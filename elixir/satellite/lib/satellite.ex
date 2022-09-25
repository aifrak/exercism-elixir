defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree(preorder, inorder) do
    with :ok <- validate_lengths(preorder, inorder),
         :ok <- validate_same_items(preorder, inorder),
         :ok <- validate_unique_items(preorder) do
      tree(preorder, inorder, []) |> then(&{:ok, &1})
    end
  end

  defp tree([], [], _), do: {}

  defp tree([hd | tl_preorder], [hd | tl_inorder], read_items),
    do: {{}, hd, tree(tl_preorder, tl_inorder, [hd | read_items])}

  defp tree([hd_preorder | tl_preorder], [hd_inorder | tl_inorder], read_items) do
    cond do
      hd_preorder in read_items or hd_inorder in read_items ->
        tree(tl_preorder, tl_inorder, read_items)

      true ->
        left = {{}, hd_inorder, {}}
        right = tree(tl_preorder, tl_inorder, [hd_preorder | [hd_inorder | read_items]])

        {left, hd_preorder, right}
    end
  end

  defp validate_lengths(list_1, list_2) do
    if length(list_1) == length(list_2),
      do: :ok,
      else: {:error, "traversals must have the same length"}
  end

  defp validate_same_items(list_1, list_2) do
    if MapSet.new(list_1) === MapSet.new(list_2),
      do: :ok,
      else: {:error, "traversals must have the same elements"}
  end

  defp validate_unique_items(list) do
    if list == Enum.uniq(list),
      do: :ok,
      else: {:error, "traversals must contain unique items"}
  end
end
