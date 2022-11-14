defmodule React do
  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  @doc """
  Start a reactive system
  """
  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells) do
    Agent.start_link(fn ->
      Enum.reduce(cells, %{inputs: %{}, outputs: %{}, callbacks: %{}}, fn
        {:input, name, value}, acc -> put_in(acc.inputs[name], value)
        {:output, name, args, fun}, acc -> put_in(acc.outputs[name], %{args: args, fun: fun})
      end)
    end)
  end

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name), do: Agent.get(cells, &value(&1, cell_name))

  defp value(%{inputs: inputs}, cell_name) when is_map_key(inputs, cell_name),
    do: inputs[cell_name]

  defp value(%{outputs: outputs} = state, cell_name) when is_map_key(outputs, cell_name) do
    %{args: args, fun: fun} = outputs[cell_name]
    apply(fun, Enum.map(args, &value(state, &1)))
  end

  @doc """
  Set the value of an input cell
  """
  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value) do
    Agent.update(cells, fn state ->
      state.inputs[cell_name]
      |> put_in(value)
      |> tap(&Enum.each(&1.callbacks, fn callback -> may_notify(callback, state, &1) end))
    end)
  end

  defp may_notify({callback_name, %{cell_name: cell_name, fun: fun}}, old_state, new_state) do
    old_state = value(old_state, cell_name)
    new_value = value(new_state, cell_name)

    if old_state != new_value, do: fun.(callback_name, new_value)
  end

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    Agent.update(
      cells,
      &put_in(&1.callbacks[callback_name], %{cell_name: cell_name, fun: callback})
    )
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, _, callback_name),
    do: Agent.update(cells, &(pop_in(&1.callbacks[callback_name]) |> elem(1)))
end
