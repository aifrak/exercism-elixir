defmodule TopSecret do
  @definition_markers [:def, :defp]

  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part({marker, _, args} = ast, acc) when marker in @definition_markers,
    do: {ast, [decode_part(args) | acc]}

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp decode_part([{_, _, nil} | _]), do: ""
  defp decode_part([{:when, _, args} | _]), do: decode_part(args)
  defp decode_part([{name, _, args} | _]), do: decode_function(name, args)

  defp decode_function(name, args) do
    name
    |> Atom.to_string()
    |> String.slice(0, length(args))
  end

  def decode_secret_message(string) do
    {_ast, acc} =
      string
      |> to_ast()
      |> Macro.prewalk([], &TopSecret.decode_secret_message_part/2)

    acc
    |> Enum.reverse()
    |> Enum.join()
  end
end
