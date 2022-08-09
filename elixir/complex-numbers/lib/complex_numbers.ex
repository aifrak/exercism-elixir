defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real(a), do: do_real(a)

  defp do_real({real, _}), do: real
  defp do_real(a), do: a

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary(a), do: do_imaginary(a)

  defp do_imaginary({_, imaginary}), do: imaginary
  defp do_imaginary(_), do: 0.0

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul(a, b) do
    ra = do_real(a)
    ia = do_imaginary(a)

    rb = do_real(b)
    ib = do_imaginary(b)

    rx = ra * rb - ia * ib
    ix = ia * rb + ra * ib

    {rx, ix}
  end

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add(a, b), do: {do_real(a) + do_real(b), do_imaginary(a) + do_imaginary(b)}

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub(a, b), do: {do_real(a) - do_real(b), do_imaginary(a) - do_imaginary(b)}

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div(a, b) do
    ra = do_real(a)
    ia = do_imaginary(a)

    rb = do_real(b)
    ib = do_imaginary(b)

    rx = (ra * rb + ia * ib) / (:math.pow(rb, 2) + :math.pow(ib, 2))
    ix = (ia * rb - ra * ib) / (:math.pow(rb, 2) + :math.pow(ib, 2))

    {rx, ix}
  end

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs(a), do: :math.sqrt(:math.pow(do_real(a), 2) + :math.pow(do_imaginary(a), 2))

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate(a), do: {do_real(a), -do_imaginary(a)}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp(a) do
    ra = do_real(a)
    ia = do_imaginary(a)

    rx = :math.exp(ra) * :math.cos(ia)
    ix = :math.exp(ra) * :math.sin(ia)

    {rx, ix}
  end
end
