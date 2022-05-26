defmodule TakeANumber do
  def start(), do: spawn(fn -> receive_loop(0) end)

  defp receive_loop(state) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, state)
        receive_loop(state)

      {:take_a_number, sender_pid} ->
        state = state + 1
        send(sender_pid, state)
        receive_loop(state)

      :stop ->
        nil

      _ ->
        receive_loop(state)
    end
  end
end
