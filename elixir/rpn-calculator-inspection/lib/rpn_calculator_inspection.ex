defmodule RPNCalculatorInspection do
  @timeout_in_ms 100

  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)

    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    status =
      receive do
        {:EXIT, ^pid, :normal} -> :ok
        {:EXIT, ^pid, _} -> :error
      after
        @timeout_in_ms -> :timeout
      end

    Map.put_new(results, input, status)
  end

  def reliability_check(_, []), do: %{}

  def reliability_check(calculator, inputs) do
    old_trap_exit = Process.flag(:trap_exit, true)

    inputs
    |> Enum.map(&start_reliability_check(calculator, &1))
    |> Enum.reduce(%{}, &await_reliability_check_result/2)
    |> tap(fn _ -> Process.flag(:trap_exit, old_trap_exit) end)
  end

  def correctness_check(_, []), do: []

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Task.await_many(@timeout_in_ms)
  end
end
