defmodule FileSniffer do
  @media_types %{
    "application/octet-stream" => %{extension: :exe, binary: <<0x7F, 0x45, 0x4C, 0x46>>},
    "image/bmp" => %{extension: :bmp, binary: <<0x42, 0x4D>>},
    "image/png" => %{extension: :png, binary: <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>},
    "image/jpg" => %{extension: :jpg, binary: <<0xFF, 0xD8, 0xFF>>},
    "image/gif" => %{extension: :gif, binary: <<0x47, 0x49, 0x46>>}
  }

  @types_by_extension Map.new(@media_types, fn {type, %{extension: extension}} ->
                        {extension, type}
                      end)
  @types_by_binary Map.new(@media_types, fn {type, %{binary: binary}} -> {binary, type} end)

  def type_from_extension(extension), do: @types_by_extension[String.to_atom(extension)]

  def type_from_binary(file_binary) do
    @types_by_binary
    |> Enum.find(fn {binary, _} -> String.starts_with?(file_binary, binary) end)
    |> then(fn
      {_, type} -> type
      _ -> nil
    end)
  end

  def verify(file_binary, extension) do
    extension_type = type_from_extension(extension)
    binary_type = type_from_binary(file_binary)

    if extension_type == binary_type,
      do: {:ok, extension_type},
      else: {:error, "Warning, file format and file extension do not match."}
  end
end
