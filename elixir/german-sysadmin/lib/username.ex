defmodule Username do
  @valid_characters [?_ | Enum.to_list(?a..?z)]

  def sanitize(username) do
    username
    |> Enum.map(fn char ->
      case char do
        ?ä -> 'ae'
        ?ö -> 'oe'
        ?ü -> 'ue'
        ?ß -> 'ss'
        char when char in @valid_characters -> char
        _ -> ''
      end
    end)
    |> List.flatten()
  end
end
