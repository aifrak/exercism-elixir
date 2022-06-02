# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]

  def new(id, register_to), do: %__MODULE__{plot_id: id, registered_to: register_to}
end

defmodule Plot.Map do
  def new, do: %{}

  def list(plots), do: Map.values(plots)

  def add(plots, plot), do: Map.put_new(plots, plot.plot_id, plot)

  def get(plots, id) do
    plot = plots[id]

    if is_struct(plot, Plot),
      do: plot,
      else: {:not_found, "plot is unregistered"}
  end

  def delete(plots, plot_id), do: Map.delete(plots, plot_id)
end

defmodule CommunityGarden do
  use Agent

  @initial_next_id 1

  def start(_opts \\ []), do: Agent.start(&init_state/0)

  def list_registrations(pid), do: Agent.get(pid, &Plot.Map.list(&1.plots))

  def register(pid, register_to) do
    pid
    |> next_id()
    |> Plot.new(register_to)
    |> tap(&add(pid, &1))
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn state ->
      updated_plots = Plot.Map.delete(state.plots, plot_id)

      %{state | plots: updated_plots}
    end)
  end

  def get_registration(pid, plot_id), do: Agent.get(pid, &Plot.Map.get(&1.plots, plot_id))

  defp init_state, do: %{plots: Plot.Map.new(), next_id: @initial_next_id}

  defp add(pid, plot) do
    Agent.update(pid, fn state ->
      updated_plots = Plot.Map.add(state.plots, plot)

      %{state | plots: updated_plots}
    end)
  end

  defp next_id(pid) do
    %{next_id: id} =
      Agent.get_and_update(pid, fn state ->
        new_next_id = state.next_id + 1
        new_state = %{state | next_id: new_next_id}

        {state, new_state}
      end)

    id
  end
end
