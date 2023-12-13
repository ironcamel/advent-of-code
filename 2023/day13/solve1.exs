defmodule Main do

  def main() do
    #halls = "input-small.txt" |> parse_input
    halls = "input-large.txt" |> parse_input
    #halls = "foo.txt" |> parse_input

    halls
    |> Enum.with_index
    |> Enum.map(fn {hall, i} ->
      #p i
      find_reflection(hall)
    end)
    |> Enum.sum()

  end

  def print(rows) do
    rows
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts

    p("---")
  end

  def find_reflection({rows, cols}) do
    #print rows
    i = find_reflection(rows)
    if i do
      100 * i
    else
      #dbg
      find_reflection(cols) || 0
    end
  end

  def find_reflection(rows) do
    1..(length(rows) - 1)
    |> Enum.find(fn n -> mirror?(rows, n) end)
  end

  def mirror?(rows, i) do
    n = Enum.min([i, length(rows) - i])
    part1 = rows |> Enum.drop(i - n) |> Enum.take(n)
    part2 = rows |> Enum.drop(i) |> Enum.take(n) |> Enum.reverse()
    #dbg()
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

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> Main.p

# 22316 - too low
