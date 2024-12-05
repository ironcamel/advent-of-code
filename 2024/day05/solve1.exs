defmodule Main do
  def main() do
    {rules, rows} = parse_input("input-large.txt")

    rows
    |> Enum.filter(fn row -> check_row(row, rules) end)
    |> Enum.map(fn row -> Enum.at(row, div(length(row) - 1, 2)) end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def order_row(row, rules), do: Enum.sort(row, fn a, b -> MapSet.member?(rules, [a, b]) end)

  def check_row(row, order), do: order_row(row, order) == row

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.trim() |> String.split("\n\n")
    rules = part1 |> String.split("\n") |> Enum.map(&String.split(&1, "|")) |> MapSet.new()
    rows = part2 |> String.split("\n") |> Enum.map(fn s -> String.split(s, ",") end)
    {rules, rows}
  end
end

Main.main() |> IO.puts()

# 143 - input-small.txt answer
# 5329 - input-large.txt answer
