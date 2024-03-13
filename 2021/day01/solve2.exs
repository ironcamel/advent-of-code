defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.to_integer(&1))
  end
end

Main.main() |> IO.puts()

# 5 - input-small.txt answer
# 1516 - input-large.txt answer
