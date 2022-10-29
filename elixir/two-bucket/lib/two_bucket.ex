defmodule TwoBucket do
  alias TwoBucket.Bucket

  defstruct [:bucket_one, :bucket_two, :moves]
  @type t :: %TwoBucket{bucket_one: integer, bucket_two: integer, moves: integer}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.
  """
  @spec measure(
          size_one :: integer,
          size_two :: integer,
          goal :: integer,
          start_bucket :: :one | :two
        ) :: {:ok, TwoBucket.t()} | {:error, :impossible}
  def measure(size_one, size_two, goal, start_bucket) do
    with history <- [{Bucket.new(size_one), Bucket.new(size_two)}],
         {moves, {one, two}} <- move(history, goal, start_bucket) do
      {:ok, %__MODULE__{bucket_one: one.liters, bucket_two: two.liters, moves: moves}}
    end
  end

  defp move(history, goal, target)

  defp move([{one, two} = buckets | _] = history, goal, _)
       when one.liters == goal or two.liters == goal,
       do: {length(history) - 1, buckets}

  defp move([buckets | rest] = history, goal, target),
    do: if(buckets in rest, do: {:error, :impossible}, else: do_move(history, goal, target))

  defp do_move([{%{liters: 0}, _} = buckets | _] = history, goal, :one),
    do: move([fill(buckets, :one) | history], goal, :one)

  defp do_move([{_, %{liters: 0}} = buckets | _] = history, goal, :two),
    do: move([fill(buckets, :two) | history], goal, :two)

  defp do_move([{%{liters: 0} = one, _} = buckets | _] = history, goal, :two)
       when one.size - one.liters == goal,
       do: move([fill(buckets, :one) | history], goal, :two)

  defp do_move([{_, %{liters: 0} = two} = buckets | _] = history, goal, :one)
       when two.size - two.liters == goal,
       do: move([fill(buckets, :two) | history], goal, :one)

  defp do_move([{_, %{liters: size, size: size}} = buckets | _] = history, goal, :one),
    do: move([empty(buckets, :two) | history], goal, :one)

  defp do_move([{%{liters: size, size: size}, _} = buckets | _] = history, goal, :two),
    do: move([empty(buckets, :one) | history], goal, :two)

  defp do_move([buckets | _] = history, goal, target),
    do: move([transfer(buckets, target, other(target)) | history], goal, target)

  defp transfer({one, two}, :one, :two), do: Bucket.transfer(one, two)

  defp transfer({one, two}, :two, :one),
    do: Bucket.transfer(two, one) |> then(fn {two, one} -> {one, two} end)

  defp fill({one, two}, :one), do: {Bucket.fill(one), two}
  defp fill({one, two}, :two), do: {one, Bucket.fill(two)}

  defp empty({one, two}, :one), do: {Bucket.empty(one), two}
  defp empty({one, two}, :two), do: {one, Bucket.empty(two)}

  defp other(:one), do: :two
  defp other(:two), do: :one
end
