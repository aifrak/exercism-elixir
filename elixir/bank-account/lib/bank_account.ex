defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {:ok, account} = Agent.start_link(fn -> 0 end)
    account
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: :ok
  def close(account), do: Agent.stop(account)

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :amount_must_be_positive}
  def balance(account) do
    with :ok <- validate_opened_account(account) do
      do_balance(account)
    else
      error -> error
    end
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(account, amount) do
    with :ok <- validate_amount(amount),
         :ok <- validate_opened_account(account) do
      do_deposit(account, amount)
    else
      error -> error
    end
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(account, amount) do
    with :ok <- validate_amount(amount),
         balance when is_integer(balance) <- balance(account),
         :ok <- validate_withdraw(balance, amount) do
      do_withdraw(account, amount)
    else
      error -> error
    end
  end

  defp do_balance(account), do: Agent.get(account, & &1)

  defp do_deposit(account, amount), do: Agent.update(account, &(&1 + amount))

  defp do_withdraw(account, amount), do: Agent.update(account, &(&1 - amount))

  defp validate_opened_account(account) do
    if Process.alive?(account), do: :ok, else: {:error, :account_closed}
  end

  defp validate_amount(amount) do
    if amount >= 0, do: :ok, else: {:error, :amount_must_be_positive}
  end

  defp validate_withdraw(balance, amount) do
    if balance - amount >= 0, do: :ok, else: {:error, :not_enough_balance}
  end
end
