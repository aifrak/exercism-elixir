defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    {expected, words} = parse_statement(puzzle)
    do_solve(%{}, words, expected, String.length(expected), 0)
  end

  defp parse_statement(puzzle) do
    puzzle
    |> String.split([" + ", " == "])
    |> Enum.slide(-1, 0)
    |> then(fn [expected | words] -> {expected, words} end)
  end

  defp do_solve(solution, _, _, max, max), do: solution

  defp do_solve(solution, words, expected, max, index) do
    slice_range = 0..index
    sliced_words = slice_words(words, slice_range, expected)
    sliced_expected = String.slice(expected, slice_range)

    uniq_letters = uniq_letters(words, expected)

    uniq_unsolved_letters =
      uniq_letters(sliced_words, sliced_expected) |> Enum.reject(&Map.has_key?(solution, &1))

    uniq_unsolved_letters
    |> length()
    |> all_combinations(solution)
    |> Enum.reduce_while(nil, fn combination, acc ->
      new_solution = new_solution(solution, uniq_unsolved_letters, combination)

      with true <- uniq_digit?(Map.values(new_solution)),
           true <- all_words_start_with_positive?(new_solution, sliced_words, expected),
           true <- partially_solved?(new_solution, sliced_words, sliced_expected),
           :solved <- solved_status(new_solution, uniq_letters, words, expected) do
        {:halt, new_solution}
      else
        :partially_solved ->
          next_solution = do_solve(new_solution, words, expected, max, index + 1)

          if solved_status(next_solution, uniq_letters, words, expected) == :solved,
            do: {:halt, next_solution},
            else: {:cont, acc}

        _ ->
          {:cont, acc}
      end
    end)
  end

  defp solved_status(solution, uniq_letters, words, expected) do
    cond do
      count_keys(solution) < length(uniq_letters) -> :partially_solved
      fully_solved?(solution, words, expected) -> :solved
      true -> :not_solution
    end
  end

  defp all_combinations(1, solution) do
    solved_digits = Map.values(solution)

    0..9
    |> Enum.reject(&(&1 in solved_digits))
    |> Enum.map(&[&1])
  end

  defp all_combinations(size, solution) do
    solved_digits = Map.values(solution)

    0..9
    |> Enum.reject(&(&1 in solved_digits))
    |> Enum.flat_map(fn digit ->
      (size - 1)
      |> all_combinations(solution)
      |> Enum.map(&[digit | &1])
    end)
  end

  defp new_solution(old_solution, letters, combination),
    do: letters |> Enum.zip(combination) |> Map.new() |> Map.merge(old_solution)

  defp slice_words(words, range, expected) do
    pad = "."
    padding = String.length(expected)

    words
    |> Enum.map(&String.pad_leading(&1, padding, pad))
    |> Enum.map(fn str ->
      str
      |> String.slice(range)
      |> String.replace_leading(pad, "")
    end)
    |> Enum.reject(&(&1 == ""))
  end

  defp fully_solved?(solution, words, expected), do: solved?(solution, words, expected, &==/2)
  defp partially_solved?(solution, words, expected), do: solved?(solution, words, expected, &<=/2)

  defp solved?(solution, words, expected, compare_fun),
    do: compare_fun.(Enum.sum(solve_words(words, solution)), solve_word(expected, solution))

  defp solve_words(words, solution), do: Enum.map(words, &solve_word(&1, solution))

  defp solve_word(word, solution) do
    solved = Enum.map_join(to_charlist(word), &solution[&1])
    if solved == "", do: -1, else: String.to_integer(solved)
  end

  defp uniq_digit?(list), do: list == Enum.uniq(list)

  defp all_words_start_with_positive?(solution, words, expected),
    do: [expected | words] |> Enum.uniq() |> Enum.all?(&start_with_positive?(&1, solution))

  defp start_with_positive?(<<letter, _::bits>>, solution), do: solution[letter] > 0

  defp uniq_letters(words, expected),
    do: [expected | words] |> Enum.join() |> to_charlist() |> Enum.uniq()

  defp count_keys(nil), do: 0
  defp count_keys(solution), do: solution |> Map.keys() |> length()
end
