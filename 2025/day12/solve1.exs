defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.filter(fn {w, h, num_shapes} ->
      area_needed = num_shapes |> Enum.map(fn n -> 9 * n end) |> Enum.sum()
      area_needed <= w * h
    end)
    |> Enum.count()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n\n")
    |> List.last()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [area, num_shapes] = String.split(line, ": ")
      [w, h] = String.split(area, "x") |> Enum.map(&String.to_integer/1)
      num_shapes = num_shapes |> String.split() |> Enum.map(&String.to_integer/1)
      {w, h, num_shapes}
    end)
  end
end

Main.main() |> IO.puts()

# 406 - input-large.txt answer
