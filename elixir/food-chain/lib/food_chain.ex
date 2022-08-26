defmodule FoodChain do
  @last_verse 8

  @foods [
    %{animal: "fly", comment: "", catch: ""},
    %{animal: "spider", comment: "It wriggled and jiggled and tickled inside her.", catch: ""},
    %{animal: "bird", comment: "How absurd to swallow a bird!", catch: ""},
    %{animal: "cat", comment: "Imagine that, to swallow a cat!", catch: ""},
    %{animal: "dog", comment: "What a hog, to swallow a dog!", catch: ""},
    %{animal: "goat", comment: "Just opened her throat and swallowed a goat!", catch: ""},
    %{animal: "cow", comment: "I don't know how she swallowed a cow!", catch: ""},
    %{animal: "horse", comment: "", catch: ""}
  ]

  @catch_spider "spider that wriggled and jiggled and tickled inside her"
  @chains @foods
          |> Enum.map_reduce("", fn
            food, "spider" -> {%{food | catch: @catch_spider}, food.animal}
            food, previous_animal -> {%{food | catch: previous_animal}, food.animal}
          end)
          |> elem(0)
          |> get_in([Access.filter(&(&1.animal not in ["fly", "horse"]))])
          |> Enum.reverse()

  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop),
    do: Enum.reduce(stop..start, [], &[verse(&1, &1) | &2]) |> Enum.join("\n")

  defp verse(start, stop) do
    food = Enum.at(@foods, start - 1)

    [
      "I know an old lady who swallowed a #{food.animal}.",
      food.comment,
      chains(start),
      death_comment(start, stop)
    ]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp chains(start) when start > 1 and start < @last_verse do
    @chains
    |> Enum.drop(@last_verse - start - 1)
    |> Enum.map(&"She swallowed the #{&1.animal} to catch the #{&1.catch}.")
    |> Enum.join("\n")
  end

  defp chains(_), do: ""

  defp death_comment(@last_verse, @last_verse), do: "She's dead, of course!"
  defp death_comment(_, _), do: "I don't know why she swallowed the fly. Perhaps she'll die."
end
