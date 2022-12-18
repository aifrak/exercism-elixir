defmodule Forth do
  alias Evaluator

  @opaque evaluator :: Evaluator.t()

  @definition_start ":"
  @definition_end ";"

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new(), do: %Evaluator{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s |> String.split(~r/#{@definition_end}/, trim: true) |> Enum.reduce(ev, &eval_statement/2)
  end

  defp eval_statement(statement, ev) do
    with {:ok, new_ev} <- statement |> tokens() |> eval_tokens(ev) do
      new_ev
    else
      {:error, :stack_underflow} -> raise Forth.StackUnderflow
      {:error, :invalid_word} -> raise Forth.InvalidWord
      {:error, :unknown_word} -> raise Forth.UnknownWord
      {:error, :division_by_zero} -> raise Forth.DivisionByZero
    end
  end

  defp tokens(statement), do: statement |> String.trim() |> String.split(~r/[\s|[:cntrl:]]/u)

  defp eval_tokens(tokens, ev)
  defp eval_tokens([], ev), do: {:ok, Map.update!(ev, :stack, &Enum.reverse/1)}

  defp eval_tokens([@definition_start, word | tokens], ev),
    do: if(number?(word), do: {:error, :invalid_word}, else: {:ok, define(word, tokens, ev)})

  defp eval_tokens([h | t], ev) do
    word = Evaluator.to_word(h)

    cond do
      number?(word) ->
        eval_tokens(t, Map.update!(ev, :stack, &[String.to_integer(word) | &1]))

      Map.has_key?(ev.definitions, word) ->
        with {:ok, new_ev} <- apply_definition(word, ev), do: eval_tokens(t, new_ev)

      true ->
        {:error, :unknown_word}
    end
  end

  defp define(word, tokens, ev) do
    eval_tokens(tokens, ev)
    |> get_operations(tokens, ev)
    |> then(&put_in(ev, [Access.key(:definitions), Access.key(Evaluator.to_word(word))], &1))
  end

  defp apply_definition(word, ev) do
    Enum.reduce_while(ev.definitions[word], {:ok, ev}, fn fun, {:ok, acc} ->
      with {:ok, new_stack} <- fun.(acc.stack) do
        {:cont, {:ok, %{acc | stack: new_stack}}}
      else
        error -> {:halt, error}
      end
    end)
  end

  defp get_operations({:ok, ev}, _, _), do: Evaluator.add_stack_as_operation(ev.stack)

  defp get_operations({:error, :stack_underflow}, tokens, ev),
    do: Evaluator.tokens_to_operations(tokens, ev)

  defp number?(str), do: str =~ ~r/-?\d+/

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    Enum.reduce(ev.stack, [], &[Integer.to_string(&1) | &2]) |> Enum.reverse() |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
