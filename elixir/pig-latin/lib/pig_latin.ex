defmodule PigLatin do
  @separator " "

  @vowels_str "aeiou"
  @vowels String.to_charlist(@vowels_str)

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.splitter(@separator)
    |> Enum.map_join(@separator, &translate_word/1)
  end

  defp translate_word("qu" <> tail), do: "#{tail}quay"
  defp translate_word("x" <> <<c2::utf8>> <> _ = word) when c2 not in @vowels, do: "#{word}ay"
  defp translate_word("y" <> <<c2::utf8>> <> _ = word) when c2 not in @vowels, do: "#{word}ay"
  defp translate_word(<<c1::utf8, c2::utf8>> <> "y" <> tail), do: "y#{tail}#{[c1, c2]}ay"
  defp translate_word(<<c1::utf8>> <> _ = word) when c1 in @vowels, do: "#{word}ay"
  defp translate_word(<<c1::utf8>> <> "y"), do: "y#{[c1]}ay"
  defp translate_word(<<c1::utf8>> <> "qu" <> tail), do: "#{tail}#{[c1]}quay"

  defp translate_word(word) do
    groups = Regex.named_captures(~r/^(?<consonants>[^#{@vowels_str}]+)(?<tail>\w+)/, word)

    "#{groups["tail"]}#{groups["consonants"]}ay"
  end
end
