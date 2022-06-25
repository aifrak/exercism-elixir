defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = String.trim(input)

    cond do
      silent?(input) -> "Fine. Be that way!"
      yell?(input) and ask?(input) -> "Calm down, I know what I'm doing!"
      yell?(input) -> "Whoa, chill out!"
      ask?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  defp yell?(input), do: input == String.upcase(input) and String.match?(input, ~r/[A-ZА-Я]+/)

  defp ask?(input), do: String.ends_with?(input, "?")

  defp silent?(input), do: input == ""
end
