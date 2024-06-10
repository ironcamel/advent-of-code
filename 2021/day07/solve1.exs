defmodule Main do
  def main() do
    positions = "input-large.txt" |> parse_input()

    positions
    |> MapSet.new()
    |> Enum.map(fn pos -> cost(positions, pos) end)
    |> Enum.min()
  end

  def cost(positions, pos) do
    positions
    |> Enum.map(fn p -> abs(pos - p) end)
    |> Enum.sum()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

Main.main() |> IO.puts()

# 37 - input-small.txt answer
# 344138 - input-large.txt answer
