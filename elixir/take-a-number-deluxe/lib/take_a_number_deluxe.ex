defmodule TakeANumberDeluxe do
  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    min = init_arg[:min_number]
    max = init_arg[:max_number]
    timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)

    case TakeANumberDeluxe.State.new(min, max, timeout) do
      {:ok, state} -> GenServer.start_link(__MODULE__, state)
      {:error, error} -> {:error, error}
    end
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset_state)
  end

  # Server callbacks

  @impl GenServer
  def init(state) do
    timeout = state.auto_shutdown_timeout

    {:ok, state, timeout}
  end

  @impl GenServer
  def handle_call(:report_state, _, state) do
    timeout = state.auto_shutdown_timeout

    {:reply, state, state, timeout}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _, state) do
    timeout = state.auto_shutdown_timeout

    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} ->
        reply = {:ok, new_number}

        {:reply, reply, new_state, timeout}

      {:error, error} ->
        reply = {:error, error}

        {:reply, reply, state, timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _, state) do
    timeout = state.auto_shutdown_timeout

    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:ok, next_number, new_state} ->
        reply = {:ok, next_number}

        {:reply, reply, new_state, timeout}

      {:error, error} ->
        reply = {:error, error}

        {:reply, reply, state, timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset_state, state) do
    timeout = state.auto_shutdown_timeout

    {:ok, new_state} = TakeANumberDeluxe.State.new(state.min_number, state.max_number, timeout)

    {:noreply, new_state, timeout}
  end

  @impl GenServer
  def handle_info(:timeout, state), do: {:stop, :normal, state}

  @impl GenServer
  def handle_info(_, state), do: {:noreply, state, state.auto_shutdown_timeout}
end
