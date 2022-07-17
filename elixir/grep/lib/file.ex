defmodule Grep.File do
  @enforce_keys [:path]
  defstruct [:path, lines: [], found?: false]

  @type t :: %__MODULE__{path: String.t(), lines: [Grep.Line], found?: boolean()}

  @spec new(String.t()) :: t
  def new(path), do: %__MODULE__{path: path}

  @spec parse(t) :: t
  def parse(file) do
    file.path
    |> File.stream!()
    |> Stream.with_index()
    |> Stream.map(fn {text, index} -> Grep.Line.new(index + 1, text) end)
    |> then(&struct(file, lines: &1))
  end

  @spec may_mark_as_found(t, fun()) :: t
  def may_mark_as_found(file, match_fun) do
    file.lines
    |> Enum.any?(&match_fun.(&1.text))
    |> then(&struct(file, found?: &1))
  end

  @spec add_found_lines(t, fun()) :: t
  def add_found_lines(file, match_fun) do
    file.lines
    |> Enum.filter(&match_fun.(&1.text))
    |> then(&struct(file, lines: &1, found?: not Enum.empty?(&1)))
  end
end
