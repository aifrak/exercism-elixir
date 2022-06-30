defmodule Garden do
  @plants %{
    ?C => :clover,
    ?G => :grass,
    ?R => :radishes,
    ?V => :violets
  }

  @default_students ~w(alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry)a

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_students) do
    student_names = Enum.sort(student_names)
    students = %{tail: student_names, all: student_names}
    plants = Map.new(student_names, &{&1, {}})

    do_info(info_string, students, plants)
  end

  defp do_info(<<>>, _, plants), do: plants

  defp do_info(<<?\n, rest::binary>>, %{all: all_names} = students, plants),
    do: do_info(rest, %{students | tail: all_names}, plants)

  defp do_info(<<p1, p2, rest::binary>>, %{tail: [name | tail]} = students, plants) do
    updated_plants = Map.update!(plants, name, &add_plants(&1, p1, p2))

    do_info(rest, %{students | tail: tail}, updated_plants)
  end

  defp add_plants(plants, p1, p2) do
    plants
    |> Tuple.append(@plants[p1])
    |> Tuple.append(@plants[p2])
  end
end
