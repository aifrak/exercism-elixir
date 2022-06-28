defmodule House do
  @verses [
    Verse.new("", "the horse and the hound and the horn"),
    Verse.new("belonged to", "the farmer sowing his corn"),
    Verse.new("kept", "the rooster that crowed in the morn"),
    Verse.new("woke", "the priest all shaven and shorn"),
    Verse.new("married", "the man all tattered and torn"),
    Verse.new("kissed", "the maiden all forlorn"),
    Verse.new("milked", "the cow with the crumpled horn"),
    Verse.new("tossed", "the dog"),
    Verse.new("worried", "the cat"),
    Verse.new("killed", "the rat"),
    Verse.new("ate", "the malt"),
    Verse.new("lay in", "the house that Jack built.")
  ]

  @verses_length length(@verses)
  @last_verse_index @verses_length - 1

  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop), do: Enum.reduce(start..stop, "", &"#{&2}#{recite(&1)}")
  defp recite(start), do: "This is #{first_verse(start)}#{other_verses(start)}\n"

  defp first_verse(start), do: Enum.at(@verses, first_verse_index(start)).object

  defp other_verses(start) do
    @verses
    |> Enum.slice(second_verse_index(start)..@last_verse_index)
    |> Enum.reduce("", &"#{&2} that #{&1.action} #{&1.object}")
  end

  defp first_verse_index(start), do: @verses_length - start
  defp second_verse_index(start), do: first_verse_index(start) + 1
end
