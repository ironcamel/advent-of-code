defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.to_integer(&1))
  end
end

Main.main() |> IO.puts()

# 7 - input-small.txt answer
# 1475 - input-large.txt answer
