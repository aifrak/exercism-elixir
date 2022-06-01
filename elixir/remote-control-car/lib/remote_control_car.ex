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

  def display_distance(%__MODULE__{distance_driven_in_meters: meters}), do: "#{meters} meters"

  def display_battery(%__MODULE__{battery_percentage: 0}), do: "Battery empty"
  def display_battery(%__MODULE__{battery_percentage: battery}), do: "Battery at #{battery}%"

  def drive(%__MODULE__{battery_percentage: 0} = remote_car), do: remote_car

  def drive(%__MODULE__{} = remote_car) do
    remote_car
    |> Map.update!(:distance_driven_in_meters, &(&1 + @drive_meters))
    |> Map.update!(:battery_percentage, &(&1 * battery_drain_complement()))
  end

  defp battery_drain_complement(), do: 1 - @battery_drain_percentage / 100
end
