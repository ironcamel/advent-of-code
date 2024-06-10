defmodule Main do
  def main() do
    positions = "input-large.txt" |> parse_input()

    0..Enum.max(positions)
    |> MapSet.new()
    |> Enum.map(fn pos -> cost(positions, pos) end)
    |> Enum.min()
  end

  def cost(positions, pos) do
    positions
    |> Enum.map(fn p ->
      n = abs(pos - p)
      div(n * (n + 1), 2)
    end)
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

# 168 - input-small.txt answer
# 94862124 - input-large.txt answer
