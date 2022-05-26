defmodule NameBadge do
  @department_owner_label "owner"
  @separator " - "

  def print(id, name, department) do
    badge_id = badge_id(id)
    badge_department = badge_department(department)

    []
    |> may_add_id(badge_id)
    |> add_name(name)
    |> add_department(badge_department)
    |> Enum.reverse()
    |> Enum.join(@separator)
  end

  defp badge_id(id) do
    if id, do: "[#{id}]"
  end

  defp badge_department(department) do
    badge_department = if department, do: department, else: @department_owner_label

    String.upcase(badge_department)
  end

  defp may_add_id(list, id) do
    if id, do: ["#{id}" | list], else: list
  end

  defp add_name(list, name), do: ["#{name}" | list]

  defp add_department(list, department), do: ["#{department}" | list]
end
