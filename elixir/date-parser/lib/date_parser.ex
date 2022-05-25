defmodule DateParser do
  def day(), do: "([1-2]\\d|3[0-1]|0?[1-9])"

  def month(), do: "(1[0-2]|0?[1-9])"

  def year(), do: "\\d{4}"

  def day_names(), do: "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)"

  def month_names(),
    do: "(January|February|March|April|May|June|July|August|September|October|November|December)"

  def capture_day(), do: "(?<day>#{day()})"

  def capture_month(), do: "(?<month>#{month()})"

  def capture_year(), do: "(?<year>#{year()})"

  def capture_day_name(), do: "(?<day_name>#{day_names()})"

  def capture_month_name(), do: "(?<month_name>#{month_names()})"

  def capture_numeric_date(), do: "(#{capture_day()}/#{capture_month()}/#{capture_year()})"

  def capture_month_name_date(),
    do: "(#{capture_month_name()} #{capture_day()}, #{capture_year()})"

  def capture_day_month_name_date(),
    do: "(#{capture_day_name()}, #{capture_month_name()} #{capture_day()}, #{capture_year()})"

  def match_numeric_date(), do: ~r/^#{capture_numeric_date()}$/

  def match_month_name_date(), do: ~r/^#{capture_month_name_date()}$/

  def match_day_month_name_date(), do: ~r/^#{capture_day_month_name_date()}$/
end
