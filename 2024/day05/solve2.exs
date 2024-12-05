defmodule Main do
  def main() do
    {rules, rows} = parse_input("input-large.txt")

    rows
    |> Enum.reject(fn row -> check_row(row, rules) end)
    |> Enum.map(fn row -> order_row(row, rules) end)
    |> Enum.map(fn row -> row |> Enum.at(div(length(row) - 1, 2)) |> String.to_integer() end)
    |> Enum.sum()
  end

  def order_row(row, rules), do: Enum.sort(row, fn a, b -> MapSet.member?(rules, [a, b]) end)

  def check_row(row, order), do: order_row(row, order) == row

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.trim() |> String.split("\n\n")
    rules = part1 |> String.split("\n") |> Enum.map(&String.split(&1, "|")) |> MapSet.new()
    rows  = part2 |> String.split("\n") |> Enum.map(&String.split(&1, ","))
    {rules, rows}
  end
end

Main.main() |> IO.puts()

# 123 - input-small.txt answer
# 5833 - input-large.txt answer
