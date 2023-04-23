# Paint By Number

Welcome to Paint By Number on Exercism's Elixir Track.
If you need help running the tests or submitting your code, check out `HELP.md`.
If you get stuck on the exercise, check out `HINTS.md`, but try and solve it without using those first :)

## Introduction

## Bitstrings

Working with binary data is an important concept in any language, and Elixir provides an elegant syntax to write, match, and construct binary data.

In Elixir, binary data is referred to as the bitstring type. The binary data _type_ (not to be confused with binary data in general) is a specific form of a bitstring, which we will discuss in a later exercise.

Bitstring literals are defined using the bitstring special form `<<>>`. When defining a bitstring literal, it is defined in segments. Each segment has a value and type, separated by the `::` operator. The type specifies how many bits will be used to encode the value. The type can be omitted completely, which will default to a 8-bit integer value.

```elixir
# This defines a bitstring with three segments of a single bit each
<<0::1, 1::1, 0::1>>
```

Specifying the type as `::1` is a shorthand for writing `::size(1)`. You need to use the longer syntax if the bit size comes from a variable.

### Binary

When writing binary integer literals, we can write them directly in base-2 notation by prefixing the literal with `0b`. Note that they will be anyway displayed as decimal numbers when printed in tests results or when using iex.

```elixir
<<0b1011::4>> == <<11::4>>
# => true
```

### Truncating

If the value of the segment overflows the capacity of the segment's type, it will be truncated from the left.

```elixir
<<0b1011::3>> == <<0b0011::3>>
# => true
```

### Prepending and appending

You can both prepend and append to an existing bitstring using the special form. The `::bitstring` type must be used on the existing bitstring if it's of unknown size.

```elixir
value = <<0b110::3, 0b001::3>>
new_value = <<0b011::3, value::bitstring, 0b000::3>>
# => <<120, 8::size(4)>>
```

### Concatenating

We can concatenate bitstrings stored in variables using the special form. The `::bitstring` type must be used when concatenating two bitstrings of unknown sizes.

```elixir
first = <<0b110::3>>
second = <<0b001::3>>
concatenated = <<first::bitstring, second::bitstring>>
# => <<49::size(6)>>
```

### Pattern matching

Pattern matching can also be done to obtain values from the special form. You have to know the number of bits for each fragment you want to capture, with one exception: the `::bitstring` type can be used to pattern match on a bitstring of an unknown size, but this can only be used for the last fragment.

```elixir
<<value::4, rest::bitstring>> = <<0b01101001::8>>
value == 0b0110
# => true
```

### Inspecting bitstrings

~~~~exercism/note
Bitstrings might be printed (by the test runner or in iex) in a
different format than the format that was used to create them. This often
causes confusion when learning bitstrings.
~~~~

By default, bitstrings are displayed in fragments of 8 bits (a byte), even if you created them with fragments of a different size.

```elixir
<<2011::11>>
# => <<251, 3::size(3)>>
```

If you create a bitstring that represents a printable UTF-8 encoded string, it gets displayed as a string.

```elixir
<<>>
# => ""

<<65, 66, 67>>
# => "ABC"
```

## Instructions

[Paint by number][paint-by-number] (also known as _color by number_)
are black-and-white pictures meant for coloring.
The different areas of the picture are annotated with different numbers,
the numbers correspond to specific colors in a predefined color palette.
The goal is to fill the areas with the right colors,
revealing a beautiful colorful picture at the end.
It's a relaxing activity for both kids and adults.

You have been tasked with writing a paint-by-number app in Elixir.
You want your app to be able to import and export pictures in a custom data format.
You have decided to use [binary files][binary-file] to store your picture data.

~~~~exercism/note
This exercise assumes that you're familiar with [binary numbers](https://en.wikipedia.org/wiki/Binary_number)
and understand the principles behind changing binary numbers to decimal numbers
and decimal numbers to binary numbers.
~~~~

Let's imagine you have a picture of a smiley, like the one shown below.
The picture has a white background. The smiley has a black border and a yellow fill color.

This picture uses 3 colors.
Let's say we assign indices to those colors:
- `0` (binary: `0b00`) for white,
- `1` (binary: `0b01`) for black,
- `2` (binary: `0b10`) for yellow.

We can now use those color indices to represent the color of each pixel.

| Smiley                                                                                                | Smiley with color indices                                                                                     |
|-------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| ![](https://exercism-v3-icons.s3.eu-west-2.amazonaws.com/images/exercises/paint-by-number/smiley.png) | ![](https://exercism-v3-icons.s3.eu-west-2.amazonaws.com/images/exercises/paint-by-number/smiley-numbers.png) |

## 1. Calculate palette bit size

Implement the `PaintByNumber.palette_bit_size/1` function. It should take the count of colors in the palette and return how many bits are necessary to represent that many color indices as binary numbers. Color indices always start at 0 and are continuous ascending integers.

For example, representing 13 different colors require 4 bits. 4 bits can store up to 16 color indices (2^4). 3 bits would not be enough because 3 bits can only store up to 8 color indices (2^3).

```elixir
PaintByNumber.palette_bit_size(13)
# => 4
```

Note: there is no `log2` function in the Elixir standard library. You will later learn how to use [Erlang libraries][erlang-libraries] from Elixir where you can find this function. Now, solve this task with recursion and the [`Integer.pow/2`][integer-pow] function instead. If you're solving this exercise on your own computer using an older Elixir version (1.11 or lower) that doesn't have `Integer.pow/2` function, use the `Math.pow/2` function we provided in the `lib/math.ex` file for this exercise.

## 2. Create an empty picture

Implement the `PaintByNumber.empty_picture/0` function. It should return an empty bitstring.

## 3. Create a test picture

A predefined test picture will be used for manual testing of basic features of your app.
The test picture consists of 4 pixels with 4 different colors.

Implement the `PaintByNumber.test_picture/0` function. It should return a bitstring that consists of 4 segments.
Each segment should have a bit size of 2. The segments should have values 0, 1, 2, and 3.

## 4. Prepend a pixel to a picture

Implement the `PaintByNumber.prepend_pixel/3` function. It should take three arguments: a bitstring with the picture to which we're prepending, the count of colors in the palette, and the index of the color for the new pixel. It should return a bitstring with a picture with the new pixel added to the beginning.

```elixir
picture = <<2::4, 0::4>>
color_count = 13
pixel_color_index = 11

PaintByNumber.prepend_pixel(picture, color_count, pixel_color_index)
# => <<178, 0::size(4)>>
# (which is equal to <<11::4, 2::4, 0::4>>)
```

## 5. Get the first pixel from a picture

Implement the `PaintByNumber.get_first_pixel/2` function. It should take two arguments: a bitstring with the picture from which we're reading, and the count of colors in the palette. It should return the color index of the first pixel in the given picture. When given an empty picture, it should return `nil`.

```elixir
picture = <<19::5, 2::5, 18::5>>
color_count = 20

PaintByNumber.get_first_pixel(picture, color_count)
# => 19
```

## 6. Drop the first pixel from a picture

Implement the `PaintByNumber.drop_first_pixel/2` function. It should take two arguments: a bitstring with the picture from which we're removing a pixel, and the count of colors in the palette. It should return the picture without the first pixel. When given an empty picture, it should return an empty picture.

```elixir
picture = <<2::3, 5::3, 5::3, 0::3>>
color_count = 6

PaintByNumber.drop_first_pixel(picture, color_count)
# => <<180, 0::size(1)>>
# (which is equal to <<5::3, 5::3, 0::3>>)
```

## 7. Concatenate two pictures

Implement the `PaintByNumber.concat_pictures/2` function. It should take two arguments, two bitstrings. It should return a bitstrings that is the result of prepending the first argument to the second argument.

```elixir
picture1 = <<52::6, 51::6>>
picture2 = <<0::6, 34::6, 12::6>>

PaintByNumber.concat_pictures(picture1, picture2)
# => <<211, 48, 34, 12::size(6)>>
# (which is equal to <<52::6, 51::6, 0::6, 34::6, 12::6>>)
```

[paint-by-number]: https://en.wikipedia.org/wiki/Paint_by_number
[binary-file]: https://en.wikipedia.org/wiki/Binary_file
[erlang-libraries]: https://exercism.org/tracks/elixir/concepts/erlang-libraries
[integer-pow]: https://hexdocs.pm/elixir/Integer.html#pow/2

## Source

### Created by

- @angelikatyborska

### Contributed to by

- @neenjaw
- @meatball133
- @vaeng
- @glennj