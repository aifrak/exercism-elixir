defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  @registry_number_range 1000..9999

  @min_startdate 41000.0
  @max_startdate 42000.0
  @startdate_interval @max_startdate - @min_startdate

  @startdate_format "~.1f"

  def random_planet_class(), do: Enum.random(@planetary_classes)

  def random_ship_registry_number(), do: "NCC-#{Enum.random(@registry_number_range)}"

  def random_stardate(), do: @min_startdate + :rand.uniform() * @startdate_interval

  def format_stardate(stardate),
    do: :io_lib.format(@startdate_format, [stardate]) |> to_string()
end
