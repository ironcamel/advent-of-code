defmodule Main do
  def main() do
    #disk = "input-small.txt" |> parse_input()
    disk = "input-large.txt" |> parse_input()

    disk
    |> fix()
    |> Enum.sort()
    |> Enum.flat_map(fn {_k, vals} -> vals end)
    |> Enum.with_index()
    |> Enum.map(fn
      {".", _i} -> 0
      {val, i} -> i * val
    end)
    |> Enum.sum()
  end

  def fix(disk) do
    max_i = disk |> Map.keys() |> Enum.max()

    Enum.reduce(max_i..1//-1, disk, fn i, acc ->
      orig_data = disk[i] |> Enum.reject(fn val -> val == "." end)
      data = acc[i]

      open_i = Enum.find(0..i-1, fn j ->
        free_space(acc[j]) >= length(orig_data)
      end)

      if open_i do
        new_data = acc[open_i]
        free = free_space(new_data)
        new_data = Enum.reject(new_data, fn val -> val == "." end)
        new_data = new_data ++ orig_data
        new_data = new_data ++ List.duplicate(".", free - length(orig_data))

        acc
        |> Map.put(open_i, new_data)
        |> Map.put(i, Enum.map(data, &(if &1 == i, do: ".", else: &1)))
      else
        acc
      end
    end)
  end

  def free_space(data) do
    data |> Enum.reverse() |> Enum.split_while(&(&1 == ".")) |> elem(0) |> length()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.map(fn
      {[a, b], i} -> {i, List.duplicate(i, a) ++ List.duplicate(".", b)}
      {[a], i} -> {i, List.duplicate(i, a)}
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 2858 - input-small.txt answer
# 6335972980679 - input-large.txt answer
