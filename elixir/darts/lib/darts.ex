defmodule Darts do
  @circles [
    Circle.new(1, 10),
    Circle.new(5, 5),
    Circle.new(10, 1)
  ]
  @target_center {0.0, 0.0}

  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score(coordinates) do
    dart_radius = to_radius(coordinates)

    Enum.find_value(@circles, 0, &if(dart_radius <= &1.radius, do: &1.points))
  end

  defp to_radius({x, y}) do
    {center_x, center_y} = @target_center

    (Float.pow(x - center_x, 2) + Float.pow(y - center_y, 2))
    |> :math.sqrt()
  end
end
