defmodule Chessboard do
  def rank_range, do: 1..8

  def file_range, do: ?A..?H

  def ranks, do: Enum.to_list(rank_range())

  def files, do: Enum.map(file_range(), &<<&1>>)
end
