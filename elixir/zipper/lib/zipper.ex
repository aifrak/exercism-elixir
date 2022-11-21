defmodule Zipper do
  @type location :: :left | :right | :top
  @type record :: {location(), BinTree.t()}
  @type t :: %__MODULE__{
          location: location(),
          bin_tree: BinTree.t(),
          left: t() | nil,
          right: t() | nil,
          history: [record()]
        }
  @enforce_keys [:location, :bin_tree, :left, :right, :history]
  defstruct [:location, :bin_tree, :left, :right, :history]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: to_zipper(bin_tree)

  defp to_zipper(bin_tree, location \\ :top, history \\ [])
  defp to_zipper(nil, _, _), do: nil

  defp to_zipper(bin_tree, location, history) do
    child_history = [{location, bin_tree} | history]

    %__MODULE__{
      location: location,
      bin_tree: bin_tree,
      left: to_zipper(bin_tree.left, :left, child_history),
      right: to_zipper(bin_tree.right, :right, child_history),
      history: history
    }
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(zipper), do: do_to_tree(zipper.history, zipper.location, zipper.bin_tree)

  defp do_to_tree(history, location, bin_tree)
  defp do_to_tree([], _, bin_tree), do: bin_tree

  defp do_to_tree([{parent_location, parent_bin_tree} | tl], location, bin_tree) do
    do_to_tree(tl, parent_location, put_in(parent_bin_tree, [Access.key!(location)], bin_tree))
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper), do: zipper.bin_tree.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(zipper), do: zipper.left

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(zipper), do: zipper.right

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%{history: []}), do: nil

  def up(zipper) do
    [{location, bin_tree} | tl] = zipper.history
    to_zipper(bin_tree, location, tl)
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value),
    do: to_zipper(%{zipper.bin_tree | value: value}, zipper.location, zipper.history)

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left),
    do: to_zipper(%{zipper.bin_tree | left: left}, zipper.location, zipper.history)

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right),
    do: to_zipper(%{zipper.bin_tree | right: right}, zipper.location, zipper.history)
end
