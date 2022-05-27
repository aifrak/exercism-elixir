defmodule LibraryFees do
  @return_days 28
  @discount 50.0

  @monday 1

  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  def before_noon?(datetime), do: datetime.hour < 12

  def return_date(checkout_datetime) do
    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(return_days(checkout_datetime))
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> (&max(0, &1)).()
  end

  def monday?(datetime), do: Date.day_of_week(datetime) == @monday

  def calculate_late_fee(checkout, return, rate) do
    actual_return = datetime_from_string(return)
    planned_return = datetime_from_string(checkout) |> return_date()

    days_late(planned_return, actual_return)
    |> Kernel.*(rate)
    |> may_discount(actual_return)
    |> floor()
  end

  defp return_days(datetime) do
    case before_noon?(datetime) do
      true -> @return_days
      false -> @return_days + 1
    end
  end

  defp may_discount(fee, datetime) do
    case monday?(datetime) do
      true -> fee * complement(@discount)
      false -> fee
    end
  end

  defp complement(percentage), do: 1 - percentage / 100
end
