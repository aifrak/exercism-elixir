defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: any()

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new(), do: %{}

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(school, name, grade) do
    if Map.has_key?(school, name) do
      {:error, school}
    else
      {:ok, Map.put_new(school, name, grade)}
    end
  end

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade) do
    school
    |> Stream.filter(fn {_, g} -> g == grade end)
    |> Stream.map(fn {name, _} -> name end)
    |> Enum.sort()
  end

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school) do
    school
    |> Map.values()
    |> Stream.uniq()
    |> Enum.sort()
    |> Enum.flat_map(&grade(school, &1))
  end
end
