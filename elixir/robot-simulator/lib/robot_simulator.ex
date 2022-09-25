defmodule RobotSimulator do
  @type robot() :: any()
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @directions [:north, :east, :south, :west]
  @directions_length length(@directions)

  @clockwise 1
  @counter_clockwise -1

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, position) do
    with :ok <- validate_direction(direction),
         :ok <- validate_position(position) do
      %{direction: direction, position: position}
    end
  end

  defp validate_direction(direction) when direction in @directions, do: :ok
  defp validate_direction(_), do: {:error, "invalid direction"}

  defp validate_position({x, y}) when is_integer(x) and is_integer(y), do: :ok
  defp validate_position(_), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, ""), do: robot
  def simulate(robot, "R" <> rest), do: robot |> rotate_right() |> simulate(rest)
  def simulate(robot, "L" <> rest), do: robot |> rotate_left() |> simulate(rest)
  def simulate(robot, "A" <> rest), do: robot |> advance() |> simulate(rest)
  def simulate(_, _), do: {:error, "invalid instruction"}

  defp rotate_right(robot), do: rotate(robot, @clockwise)
  defp rotate_left(robot), do: rotate(robot, @counter_clockwise)

  defp rotate(robot, rotation) do
    @directions
    |> Enum.find_index(&(&1 == robot.direction))
    |> Kernel.+(rotation)
    |> Integer.mod(@directions_length)
    |> then(&Enum.at(@directions, &1))
    |> then(&%{robot | direction: &1})
  end

  defp advance(robot), do: %{robot | position: next_position(robot.position, robot.direction)}

  defp next_position({x, y}, :north), do: {x, y + 1}
  defp next_position({x, y}, :east), do: {x + 1, y}
  defp next_position({x, y}, :south), do: {x, y - 1}
  defp next_position({x, y}, :west), do: {x - 1, y}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(%{direction: direction}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(%{position: position}), do: position
end
