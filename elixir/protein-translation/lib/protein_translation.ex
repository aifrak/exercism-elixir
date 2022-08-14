defmodule ProteinTranslation do
  @stop "STOP"
  @codon_length 3

  @proteins_by_codon %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => @stop,
    "UAG" => @stop,
    "UGA" => @stop
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna) do
    rna
    |> StringIO.open(fn pid ->
      pid
      |> IO.binstream(@codon_length)
      |> Stream.chunk_while([], &chunk_codon/2, &after_chunk_codon/1)
      |> Enum.to_list()
      |> List.first()
    end)
    |> elem(1)
  end

  defp chunk_codon(codon, acc) do
    case ProteinTranslation.of_codon(codon) do
      {:ok, protein} when protein == @stop -> {:halt, acc}
      {:ok, protein} -> {:cont, [protein | acc]}
      _ -> {:halt, :error}
    end
  end

  defp after_chunk_codon(acc) when is_list(acc), do: {:cont, {:ok, Enum.reverse(acc)}, []}
  defp after_chunk_codon(_), do: {:cont, {:error, "invalid RNA"}, []}

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    case Map.fetch(@proteins_by_codon, codon) do
      {:ok, protein} -> {:ok, protein}
      :error -> {:error, "invalid codon"}
    end
  end
end
