defmodule Newsletter do
  @email_separator "\n"

  def read_emails(path) do
    path
    |> File.read!()
    |> String.split(@email_separator, trim: true)
  end

  def open_log(path), do: File.open!(path, [:write])

  def log_sent_email(pid, email), do: IO.puts(pid, email)

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) do
    log = open_log(log_path)

    send_and_log_sent = &if send_fun.(&1) == :ok, do: log_sent_email(log, &1)

    emails_path
    |> read_emails()
    |> Enum.each(&send_and_log_sent.(&1))

    close_log(log)
  end
end
