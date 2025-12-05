defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> combine()
    |> Enum.map(fn x..y//_ -> y - x + 1 end)
    |> Enum.sum()
  end

  def combine(ranges) do
    overlaps =
      for r1 <- ranges, r2 <- ranges, r1 != r2 and not Range.disjoint?(r1, r2) do
        {r1, r2}
      end

    if Enum.empty?(overlaps) do
      ranges
    else
      ranges = remove_overlaps(ranges, overlaps)
      joined = join_overlaps(overlaps)
      combine(MapSet.union(ranges, joined))
    end
  end

  def remove_overlaps(ranges, overlaps) do
    overlaps =
      overlaps
      |> Enum.flat_map(fn {r1, r2} -> [r1, r2] end)
      |> MapSet.new()

    MapSet.difference(ranges, overlaps)
  end

  def join_overlaps(overlaps) do
    Enum.map(overlaps, fn {x1..y1//_, x2..y2//_} ->
      if x1 < x2 do
        if y1 < y2, do: x1..y2, else: x1..y1
      else
        if y1 < y2, do: x2..y2, else: x2..y1
      end
    end)
    |> MapSet.new()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n\n")
    |> hd()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [x, y] = String.split(line, "-")
      String.to_integer(x)..String.to_integer(y)
    end)
    |> MapSet.new()
  end
end

Main.main() |> IO.puts()

# 14 - input-small.txt answer
# 339668510830757 - input-large.txt answer
