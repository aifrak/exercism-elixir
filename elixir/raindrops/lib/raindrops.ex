defmodule Raindrops do
  @factors %{
    3 => "Pling",
    5 => "Plang",
    7 => "Plong"
  }

  defguardp is_factor(number, factor) when rem(number, factor) == 0

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    @factors
    |> Enum.reduce("", &do_convert(&1, &2, number))
    |> then(&if &1 != "", do: &1, else: Integer.to_string(number))
  end

  defp do_convert({factor, sound}, acc, number) when is_factor(number, factor),
    do: "#{acc}#{sound}"

  defp do_convert(_, acc, _), do: acc
end
