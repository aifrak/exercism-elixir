defmodule CircularBuffer do
  use GenServer

  @type t :: %__MODULE__{
          buffer: [any],
          capacity: pos_integer,
          read: non_neg_integer,
          write: non_neg_integer
        }
  @enforce_keys [:capacity, :buffer]
  defstruct [:capacity, :buffer, read: 0, write: 0]

  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity), do: GenServer.start_link(__MODULE__, capacity)

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer), do: GenServer.call(buffer, :read)

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item), do: GenServer.call(buffer, {:write, item})

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item), do: GenServer.call(buffer, {:overwrite, item})

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer), do: GenServer.call(buffer, :clean)

  @impl GenServer
  @spec init(non_neg_integer) :: {:ok, CircularBuffer.t()}
  def init(capacity), do: {:ok, init_buffer(capacity)}

  @impl GenServer
  def handle_call(:read, _, %{read: r, write: w} = state) do
    if r < w,
      do: {:reply, {:ok, get_item(state)}, %{state | read: r + 1}},
      else: {:reply, {:error, :empty}, state}
  end

  @impl GenServer
  def handle_call({:write, item}, _, %{write: w} = state) do
    if full?(state),
      do: {:reply, {:error, :full}, state},
      else: {:reply, :ok, %{state | buffer: add_item(state, item), write: w + 1}}
  end

  @impl GenServer
  def handle_call(:clean, _, %{capacity: c}), do: {:reply, :ok, init_buffer(c)}

  @impl GenServer
  def handle_call({:overwrite, item}, _, %{read: r, write: w} = state) do
    new_r = if full?(state), do: r + 1, else: r
    {:reply, :ok, %{state | buffer: add_item(state, item), read: new_r, write: w + 1}}
  end

  defp init_buffer(capacity),
    do: %__MODULE__{capacity: capacity, buffer: List.duplicate(nil, capacity)}

  defp get_item(%{capacity: c, buffer: b, read: r}), do: Enum.at(b, rem(r, c))

  defp add_item(%{capacity: c, buffer: b, write: w}, item),
    do: List.replace_at(b, rem(w, c), item)

  defp full?(%{capacity: c, read: r, write: w}), do: w - r >= c
end
