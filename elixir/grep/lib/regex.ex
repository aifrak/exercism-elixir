defmodule Grep.Regex do
  @flags %{caseless: "i"}

  @spec compile(String.t(), %Grep.Options{}) :: Regex.t()
  def compile(pattern, options),
    do: Regex.compile!(may_match_line(pattern, options), to_flags(options))

  defp may_match_line(pattern, %{match_line?: true}), do: "^#{pattern}$"
  defp may_match_line(pattern, _), do: pattern

  defp to_flags(%Grep.Options{} = options), do: may_add_flag_caseless("", options)

  defp may_add_flag_caseless(flags, options),
    do: may_add_flag(flags, @flags[:caseless], options.match_case_insensitive?)

  defp may_add_flag(flags, flag, true), do: flag <> flags
  defp may_add_flag(flags, _, _), do: flags
end
