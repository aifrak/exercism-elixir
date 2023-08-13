defmodule SgfParsing do
  defmodule Sgf do
    defstruct properties: %{}, children: []
  end

  @type sgf :: %Sgf{properties: map, children: [sgf]}

  @doc """
  Parse a string into a Smart Game Format tree
  """
  @spec parse(encoded :: String.t()) :: {:ok, sgf} | {:error, String.t()}
  def parse(encoded) when encoded in ["", ";"], do: {:error, "tree missing"}
  def parse(encoded), do: encoded |> tokenize() |> parse_tokens() |> Tuple.delete_at(2)

  defp tokenize(encoded) do
    ~r/
      (?<lead>\(?)
      (?<marker>;?)
      (?<key>\w*)
      (?<property>
        \[
          (?:
            \\.       (?# Matches either an escaped character)
            |
            [^\\\]]+  (?# Matches one or more characters that are not square brackets or backslashes)
          )+
        \]
      )?
      (?<trail>\)?)
    /sx
    |> Regex.scan(encoded, capture: :all_names)
    |> Enum.reject(&Enum.all?(&1, fn elem -> elem == "" end))
    |> Enum.map(fn [k, l, m, p, t] -> %{lead: l, marker: m, key: k, property: p, trail: t} end)
  end

  defp parse_tokens(token_groups, acc \\ %Sgf{})

  defp parse_tokens([%{lead: "(", key: "", marker: "", property: "", trail: ")"} | _], _),
    do: {:error, "tree with no nodes", []}

  defp parse_tokens([%{lead: "(", key: k, marker: ";", property: "", trail: ")"} | _], _)
       when byte_size(k) > 0,
       do: {:error, "properties without delimiter", []}

  defp parse_tokens([], acc), do: {:ok, update_in(acc.children, &Enum.reverse/1), []}

  # Last closed bracket in the whole string, return accumulator
  defp parse_tokens([%{lead: "", key: "", marker: "", property: "", trail: ")"} | tl], acc),
    do: {:ok, update_in(acc.children, &Enum.reverse/1), tl}

  # Add empty node
  defp parse_tokens([%{lead: "(", key: "", marker: ";", property: "", trail: ")"} | tl], _),
    do: {:ok, %Sgf{}, tl}

  # Add single child node
  defp parse_tokens([%{lead: "(", marker: ";", key: k, trail: ")"} = elem | tl], acc)
       when map_size(acc.properties) > 0 do
    with :ok <- validate_key(k),
         {:ok, child, _} <- parse_tokens([elem], %Sgf{}),
         do: parse_tokens(tl, add_child(acc, child))
  end

  # Add first child node
  defp parse_tokens([%{lead: "(", marker: ";", key: k} | _] = token_groups, acc)
       when map_size(acc.properties) > 0 do
    with :ok <- validate_key(k),
         {:ok, child, tl} <- parse_tokens(token_groups, %Sgf{}),
         do: parse_tokens(tl, add_child(acc, child))
  end

  # Add last child node
  defp parse_tokens([%{marker: ";", key: k, trail: ")"} = token_group | tl], acc)
       when map_size(acc.properties) > 0 do
    with :ok <- validate_key(k),
         {:ok, child, _} <- parse_tokens([token_group], %Sgf{}),
         do: {:ok, add_child(acc, child), tl}
  end

  # Skip to next token group (properties already added by add_properties/2 in previous iterations)
  defp parse_tokens([%{marker: "", key: ""} | tl], acc), do: parse_tokens(tl, acc)

  # Add node with its properties
  defp parse_tokens([%{key: k} | tl] = token_groups, acc),
    do: with(:ok <- validate_key(k), do: parse_tokens(tl, add_properties(acc, token_groups)))

  defp validate_key(key) do
    if key == String.upcase(key),
      do: :ok,
      else: {:error, "property must be in uppercase", []}
  end

  defp add_properties(node, [%{key: key} = token_group | tl]) do
    tl
    |> Enum.take_while(&(&1.key == "" and &1.marker == ""))
    |> then(&[token_group | &1])
    |> Enum.map(&clean_property(&1.property))
    |> then(&put_in(node.properties[key], &1))
  end

  defp add_child(node, child), do: update_in(node.children, &[child | &1])

  defp clean_property(property), do: property |> remove_brackets() |> unescape()

  defp remove_brackets(property), do: String.slice(property, 1..-2)

  defp unescape(property) do
    property
    |> String.replace(~r/\\([[:alpha:]])/, "\\1")
    |> String.replace(~r/\t/, " ")
    |> Macro.unescape_string()
  end
end
