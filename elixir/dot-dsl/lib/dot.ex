defmodule Dot do
  defmacro graph(ast),
    do: ast |> Macro.prewalk(Graph.new(), &read_ast/2) |> elem(1) |> Macro.escape()

  defp read_ast([do: ast], graph), do: read_ast(ast, graph)
  defp read_ast({:__block__, _, _} = ast, graph), do: {ast, graph}

  defp read_ast({:graph, _, [attrs]}, graph) when is_list(attrs) do
    validate_attributes(attrs)
    {nil, Graph.put_attrs(graph, attrs)}
  end

  defp read_ast({:--, _, [{from, _, _}, {to, _, nil}]}, graph),
    do: {nil, Graph.add_edge(graph, from, to)}

  defp read_ast({:--, _, [{from, _, _}, {to, _, [attrs]}]}, graph) when is_list(attrs) do
    validate_attributes(attrs)
    {nil, Graph.add_edge(graph, from, to, attrs)}
  end

  defp read_ast({marker, _, nil}, graph), do: {nil, Graph.add_node(graph, marker)}

  defp read_ast({marker, _, [attrs]}, graph) when is_list(attrs) do
    validate_attributes(attrs)
    {nil, Graph.add_node(graph, marker, attrs)}
  end

  defp read_ast(_, _), do: raise(ArgumentError)

  defp validate_attributes(attrs),
    do: if(Keyword.keyword?(attrs), do: :ok, else: raise(ArgumentError))
end
