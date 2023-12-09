defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn row -> process_row(row) end)
    |> Enum.sum()
  end

  def process_row(row), do: process_row(row, [row])

  def process_row(row, acc) do
    if Enum.all?(row, fn x -> x == 0 end) do
      acc |> Enum.map(&List.last/1) |> Enum.sum()
    else
      new_row = row |> Enum.chunk_every(2, 1, :discard) |> Enum.map(fn [x, y] -> y - x end)
      process_row(new_row, [new_row | acc])
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  end
end

Main.main() |> IO.puts()

# 114 - input-small.txt answer
# 1479011877 - input-large.txt answer
