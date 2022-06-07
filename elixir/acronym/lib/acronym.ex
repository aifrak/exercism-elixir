defmodule Acronym do
  @separators [" ", "-", "_", ","]

  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.splitter(@separators)
    |> Stream.map(&initial_letter/1)
    |> Enum.join()
  end

  defp initial_letter(string) do
    string
    |> String.capitalize()
    |> String.first()
  end
end
