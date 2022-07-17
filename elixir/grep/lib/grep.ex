defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, paths) do
    options = Grep.Options.new(flags, paths)
    match_fun = match_fun(pattern, options)

    paths
    |> Stream.map(&grep_file(file(&1), match_fun, options))
    |> Stream.filter(& &1.found?)
    |> Enum.map_join("", &format_results(&1, options))
  end

  defp match_fun(pattern, options) do
    regex = Grep.Regex.compile(pattern, options)
    invert? = options.match_invert?

    fn text ->
      match? = String.match?(text, regex)
      (match? and not invert?) or (not match? and invert?)
    end
  end

  defp file(path), do: path |> Grep.File.new() |> Grep.File.parse()

  defp grep_file(file, match_fun, %{only_filepath?: true}),
    do: Grep.File.may_mark_as_found(file, match_fun)

  defp grep_file(file, match_fun, _), do: Grep.File.add_found_lines(file, match_fun)

  defp format_results(file, %{only_filepath?: true}), do: "#{file.path}\n"

  defp format_results(file, options),
    do: Enum.map(file.lines, &format_line(&1, file.path, options))

  defp format_line(line, path, options) do
    line.text
    |> may_append_number(line.number, options)
    |> may_append_path(path, options)
  end

  defp may_append_number(result, number, %{with_line_number?: true}), do: "#{number}:#{result}"
  defp may_append_number(result, _, _), do: result

  defp may_append_path(result, path, %{with_filepath?: true}), do: "#{path}:#{result}"
  defp may_append_path(result, _, _), do: result
end
