defmodule Main do

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn hall -> find_reflection(hall) end)
    |> Enum.sum()
  end

  def find_reflection({rows, cols}) do
    find_reflection(cols) || 100 * find_reflection(rows)
  end

  def find_reflection(rows) do
    1..(length(rows) - 1)
    |> Enum.find(fn n -> mirror?(rows, n) end)
  end

  def mirror?(rows, i) do
    n = Enum.min([i, length(rows) - i])
    part1 = rows |> Enum.drop(i - n) |> Enum.take(n)
    part2 = rows |> Enum.drop(i) |> Enum.take(n) |> Enum.reverse()
    part1 == part2
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn hall ->
      rows = String.split(hall, "\n") |> Enum.map(fn row -> row |> String.codepoints() end)
      cols = rows |> Enum.zip()
      {rows, cols}
    end)
  end
end

Main.main() |> IO.puts()

# 405 - input-small.txt answer
# 31739 - input-large.txt answer
