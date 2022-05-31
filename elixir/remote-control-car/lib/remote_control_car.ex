defmodule RemoteControlCar do
  @drive_meters 20
  @battery_drain_percentage 1.0

  @enforce_keys [:nickname]
  defstruct [
    :nickname,
    battery_percentage: 100,
    distance_driven_in_meters: 0
  ]

  def new(nickname \\ "none"), do: %__MODULE__{nickname: nickname}

  def display_distance(%__MODULE__{distance_driven_in_meters: meter}), do: "#{meter} meters"

  def display_battery(%__MODULE__{battery_percentage: 0}), do: "Battery empty"
  def display_battery(%__MODULE__{battery_percentage: battery}), do: "Battery at #{battery}%"

  def drive(%__MODULE__{battery_percentage: 0} = remote_car), do: remote_car

  def drive(%__MODULE__{} = remote_car) do
    remote_car
    |> Map.update!(:distance_driven_in_meters, &increase_distance/1)
    |> Map.update!(:battery_percentage, &drain_battery/1)
  end

  defp increase_distance(distance), do: distance + @drive_meters

  defp drain_battery(battery), do: battery * battery_drain_complement()

  defp battery_drain_complement(), do: 1 - @battery_drain_percentage / 100
end
