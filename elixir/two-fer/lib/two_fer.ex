defmodule TwoFer do
  @moduledoc """
  `Two-fer` or `2-fer` is short for two for one. One for you and one for me.
  Given a name, return a string with the message:

  ```
  One for name, one for me.
  ```

  Where "name" is the given name.
  However, if the name is missing, return the string:

  ```
  One for you, one for me.
  ```
  """

  @doc """
  Two-fer or 2-fer is short for two for one. One for you and one for me.
  """
  @spec two_fer(String.t()) :: String.t()
  def two_fer(name \\ "you") when is_binary(name), do: "One for #{name}, one for me."
end
