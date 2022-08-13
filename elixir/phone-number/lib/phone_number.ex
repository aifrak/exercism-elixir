defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """

  defstruct country: "", area: "", exchange: "", subscriber: ""

  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    with :ok <- validate_characters(raw),
         codes <- to_phone_number(raw),
         clean <- do_clean(codes),
         :ok <- validate_length(clean),
         :ok <- validate_country(codes.country),
         :ok <- validate_area(codes.area),
         :ok <- validate_exchange(codes.exchange) do
      {:ok, clean}
    end
  end

  defp do_clean(codes),
    do: "#{codes.area}#{codes.exchange}#{codes.subscriber}"

  defp to_phone_number(raw) do
    country = "(?<#{:country}>\\d?)"
    area = "(?<#{:area}>\\d{3})"
    exchange = "(?<#{:exchange}>\\d{3})"
    subscriber = "(?<#{:subscriber}>\\d{4})"
    separators = "[ .-]*"

    ("^" <>
       "\\+?#{country}" <>
       " ?[ (]?#{area}[ )]?" <>
       "#{separators}#{exchange}" <>
       "#{separators}#{subscriber}" <>
       "$")
    |> Regex.compile!()
    |> Regex.named_captures(String.trim(raw))
    |> to_struct()
  end

  defp to_struct(map) do
    map
    |> to_map()
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    |> then(&struct!(__MODULE__, &1))
  end

  defp to_map(map) when is_map(map), do: map
  defp to_map(_), do: %{}

  defp validate_length(clean_codes) do
    valid_lengths = 9..11

    if String.length(clean_codes) in valid_lengths,
      do: :ok,
      else: {:error, "incorrect number of digits"}
  end

  defp validate_characters(raw) do
    if String.match?(raw, ~r/^[\d\+-. ()]+$/),
      do: :ok,
      else: {:error, "must contain digits only"}
  end

  defp validate_country(country) do
    if String.match?(country, ~r/^1?$/),
      do: :ok,
      else: {:error, "11 digits must start with 1"}
  end

  defp validate_area(<<start::utf8, _::binary>>) when start in ?2..?9, do: :ok
  defp validate_area("0" <> _), do: {:error, "area code cannot start with zero"}
  defp validate_area("1" <> _), do: {:error, "area code cannot start with one"}

  defp validate_exchange(<<start::utf8, _::binary>>) when start in ?2..?9, do: :ok
  defp validate_exchange("0" <> _), do: {:error, "exchange code cannot start with zero"}
  defp validate_exchange("1" <> _), do: {:error, "exchange code cannot start with one"}
end
