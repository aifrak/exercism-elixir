defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @line_separator "\n"

  @header_marker "#"
  @bold_marker "__"
  @italic_marker "_"
  @list_marker "*"
  @list_line_start @list_marker <> " "

  # Refactoring done:
  # - piping
  # - use module attribute for "\n"
  # - rename "m" to "markdown"
  # - call replace_md_with_tag/1 before splitting to convert bold and italic markers into tags
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> replace_md_with_tag()
    |> String.split(@line_separator)
    |> Enum.map(&do_parse/1)
    |> Enum.join()
    |> enclose_list_with_unordered_list_tag()
  end

  # Refactoring done:
  # - piping
  # - use "cond do" instead of nested "if"
  # - use module attributes for markdown markers
  # - use new function header?/1 and list?/1 instead of conditions
  # - rename "t" to "line"
  # - rename function process/1 to do_parse/1
  # - use new function split_to_words/1
  # - use parse_text_md_level/1 (which use regex) instead of splitting words
  # - move all enclose functions into parse functions
  defp do_parse(line) do
    cond do
      header?(line) -> parse_header_md_level(line)
      list?(line) -> parse_list_md_level(line)
      true -> enclose_with_paragraph_tag(line)
    end
  end

  # Refactoring done:
  # - new function
  # - use regex instead of functions from String.starts_with?/2
  defp header?(line), do: String.match?(line, ~r/^(#{@header_marker}{1,6})[^#]+/)

  # Refactoring done: new function
  defp list?(line), do: String.starts_with?(line, @list_marker)

  # Refactoring done:
  # - piping
  # - change logic to parse and enclose
  # - add variables for "level" and "title"
  # - rename "hwt" to "line"
  # - rename parse_header_md_level/1 to header_info/1
  # - use map instead of tuple
  defp parse_header_md_level(line) do
    ~r/(?<marker>#{@header_marker}{1,6}) (?<title>.*)/
    |> Regex.named_captures(line)
    |> then(&enclose_with_header_tag(String.length(&1["marker"]), &1["title"]))
  end

  # Refactoring done:
  # - piping
  # - use interpolation
  # - replace "* " to "*"
  # - use module attributes for markdown markers
  # - move string to new function enclose_with_list_tag/1
  # - avoid splitting and joining
  # - do not use remote parse_text_md_level/1 (it is instead called in parse/1)
  defp parse_list_md_level(line),
    do: line |> String.trim_leading(@list_line_start) |> enclose_with_list_tag()

  # Refactoring done: remote parse_text_md_level/1

  # Refactoring done:
  # - use interpolation
  # - renaming variables
  # - split tuple into two arguments
  defp enclose_with_header_tag(level, title), do: "<h#{level}>#{title}</h#{level}>"

  # Refactoring done:
  # - join into single line
  # - single purpose function to match name
  # - rename "t" to "text"
  defp enclose_with_paragraph_tag(text), do: "<p>#{text}</p>"

  # Refactoring done:
  # - new function
  defp enclose_with_list_tag(text), do: "<li>#{text}</li>"

  # Refactoring done: remove join_words_with_tags/1

  # Refactoring done:
  # - piping
  # - rename "w" to "text"
  # - replace bold and italic markers at once instead of replacing prefixes then suffixes to logic
  #   for bold and italic together
  defp replace_md_with_tag(text) do
    text
    |> replace_bold_md_with_tag()
    |> replace_italic_md_with_tag()
  end

  # Refactoring done: new function
  defp replace_bold_md_with_tag(line) do
    ~r/(#{@bold_marker})([[:alnum:] ]+)(#{@bold_marker})/
    |> Regex.replace(line, "<strong>\\2</strong>")
  end

  # Refactoring done: new function
  defp replace_italic_md_with_tag(line) do
    ~r/(#{@italic_marker})([[:alnum:] ]+)(#{@italic_marker})/
    |> Regex.replace(line, "<em>\\2</em>")
  end

  # Refactoring done: remove replace_prefix_md/1
  # Refactoring done: remove replace_suffix_md/1

  # Refactoring done:
  # - join tag strings
  # - use regex instead of multiple String.reverse/1 (inspired from https://stackoverflow.com/a/16848676)
  # - rename "l" to "html"
  # - rename patch/1 to enclose_list_with_unordered_list_tag/1
  defp enclose_list_with_unordered_list_tag(html) do
    html
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace(~r|</li>(?!.*</li>)|, "</li></ul>")
  end
end
