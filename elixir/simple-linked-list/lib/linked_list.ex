defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: {}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: {elem, list}

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count(list), do: do_count(list, 0)

  defp do_count({}, count), do: count
  defp do_count({_, tail}, count), do: do_count(tail, count + 1)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(list), do: count(list) == 0

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}
  def peek({elem, _}), do: {:ok, elem}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}
  def tail({_, tail}), do: {:ok, tail}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}
  def pop({elem, tail}), do: {:ok, elem, tail}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: do_from_list(list, {}) |> reverse()

  defp do_from_list([], linked_list), do: linked_list
  defp do_from_list([head | tail], linked_list), do: do_from_list(tail, push(linked_list, head))

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list), do: list |> reverse() |> do_to_list([])

  defp do_to_list({}, list), do: list
  defp do_to_list({elem, tail}, list), do: do_to_list(tail, [elem | list])

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: do_reverse(list, LinkedList.new())

  defp do_reverse({}, reversed), do: reversed

  defp do_reverse(list, reversed) do
    {:ok, elem, tail} = pop(list)
    do_reverse(tail, push(reversed, elem))
  end
end
