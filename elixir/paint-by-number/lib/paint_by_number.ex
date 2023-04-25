defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.take_while(&(2 ** &1 < color_count))
    |> Enum.count()
  end

  def empty_picture(), do: <<>>

  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  def prepend_pixel(picture, color_count, pixel_color_index),
    do: <<pixel_color_index::size(palette_bit_size(color_count)), picture::bits>>

  def get_first_pixel(<<>>, _), do: nil

  def get_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    <<first_pixel::size(bit_size), _::bits>> = picture

    first_pixel
  end

  def drop_first_pixel(<<>>, _), do: <<>>

  def drop_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    <<_::size(bit_size), rest::bits>> = picture

    rest
  end

  def concat_pictures(picture1, picture2), do: <<picture1::bits, picture2::bits>>
end
