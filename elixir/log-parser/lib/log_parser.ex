defmodule LogParser do
  def valid_line?(line), do: line =~ ~r/^\[(DEBUG|INFO|WARNING|ERROR)\]/

  def split_line(line), do: Regex.split(~r/<[~*=-]*>/, line)

  def remove_artifacts(line), do: Regex.replace(~r/end-of-line\d+/i, line, "")

  def tag_with_user_name(line) do
    ~r/User\s+(\S+)/
    |> Regex.run(line, capture: :all_but_first)
    |> do_tag_with_user_name(line)
  end

  defp do_tag_with_user_name([user], line), do: "[USER] #{user} #{line}"
  defp do_tag_with_user_name(_, line), do: line
end
