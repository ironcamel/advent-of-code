defmodule Main do

  def main() do
    #rows = "input-small.txt" |> parse_input
    rows = "input-large.txt" |> parse_input

    #rows = [List.last(rows)]
    #rows = [Enum.at(rows, 1)]

    rows
    |> Enum.map(fn row -> process_row(row) end)
    |> Enum.sum()

  end

  def process_row(row) do
    process_row(row, [row])
  end

  def process_row(row, acc) do
    if Enum.all?(row, fn x -> x == 0 end) do
      acc
      |> Enum.map(&hd/1)
      #|> Enum.chunk_every(2, 1, :discard)
      #[ [0, 2], [2, 0], [0, 3], [3, 10] ]
      #|> Enum.map(fn [x, y] -> x - y end)
      |> Enum.reduce(fn x, acc -> x - acc end)
      # [0, 2, 0, 3, 10]
      #|> Enum.sum()
    else
      new_row =
        row
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [x, y] -> y - x end)

      process_row(new_row, [ new_row | acc ])
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> Main.p()

# 2 - input-small.txt answer
# 973 - input-large.txt answer
