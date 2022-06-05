defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts :: opts) :: {:ok, opts} | {:error, error}

  @callback handle_frame(dot :: dot, frame_number :: frame_number, opts :: opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}

      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @frame_rate 4

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _) do
    if match_frame_rate?(frame_number) do
      Map.update!(dot, :opacity, &(&1 / 2))
    else
      dot
    end
  end

  defp match_frame_rate?(frame_number), do: rem(frame_number, @frame_rate) == 0
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    velocity = Keyword.get(opts, :velocity)

    if is_number(velocity) do
      {:ok, [velocity: velocity]}
    else
      message =
        "The :velocity option is required, and its value must be a number. " <>
          "Got: #{inspect(velocity)}"

      {:error, message}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, velocity: velocity) do
    Map.update!(dot, :radius, &(&1 + (frame_number - 1) * velocity))
  end
end
