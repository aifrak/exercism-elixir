defmodule SpaceAge do
  @orbital_periods %{
    mercury: 0.2408467,
    venus: 0.61519726,
    earth: 1.0,
    mars: 1.8808158,
    jupiter: 11.862615,
    saturn: 29.447498,
    uranus: 84.016846,
    neptune: 164.79132
  }

  @seconds_in_year 31_557_600

  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet', or an error if 'planet' is not a planet.
  """
  @spec age_on(planet, pos_integer) :: {:ok, float} | {:error, String.t()}
  def age_on(planet, seconds) do
    cond do
      planet in Map.keys(@orbital_periods) -> {:ok, do_age_on(planet, seconds)}
      true -> {:error, "not a planet"}
    end
  end

  defp do_age_on(planet, seconds), do: to_year(seconds) * ratio(planet)

  defp to_year(seconds), do: seconds / @seconds_in_year

  defp ratio(planet), do: @orbital_periods[:earth] / @orbital_periods[planet]
end
