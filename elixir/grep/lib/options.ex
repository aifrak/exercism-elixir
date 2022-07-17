defmodule Grep.Options do
  defstruct with_line_number?: false,
            with_filepath?: false,
            only_filepath?: false,
            match_case_insensitive?: false,
            match_invert?: false,
            match_line?: false

  @type t :: %__MODULE__{
          with_line_number?: boolean(),
          with_filepath?: boolean(),
          only_filepath?: boolean(),
          match_case_insensitive?: boolean(),
          match_invert?: boolean(),
          match_line?: boolean()
        }

  @spec new([String.t()], [String.t()]) :: t
  def new(flags, paths), do: new() |> filepaths_to_options(paths) |> flags_to_options(flags)

  defp new(), do: %__MODULE__{}

  defp filepaths_to_options(opts, paths), do: %{opts | with_filepath?: length(paths) > 1}

  defp flags_to_options(opts, flags) do
    Enum.reduce(flags, opts, fn
      "-n", acc -> %{acc | with_line_number?: true}
      "-l", acc -> %{acc | only_filepath?: true}
      "-i", acc -> %{acc | match_case_insensitive?: true}
      "-v", acc -> %{acc | match_invert?: true}
      "-x", acc -> %{acc | match_line?: true}
      _, acc -> acc
    end)
  end
end
