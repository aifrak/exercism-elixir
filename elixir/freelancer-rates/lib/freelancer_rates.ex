defmodule FreelancerRates do
  @multiplier 8.0
  @monthly_billable_days 22

  def daily_rate(hourly_rate) do
    hourly_rate * @multiplier
  end

  def apply_discount(before_discount, discount) do
    before_discount * complement_percentage(discount)
  end

  def monthly_rate(hourly_rate, discount) do
    (discounted_daily_rate(hourly_rate, discount) * @monthly_billable_days)
    |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    (budget / discounted_daily_rate(hourly_rate, discount))
    |> Float.floor(1)
  end

  defp complement_percentage(value) do
    1 - value / 100
  end

  defp discounted_daily_rate(hourly_rate, discount) do
    hourly_rate
    |> daily_rate()
    |> apply_discount(discount)
  end
end
