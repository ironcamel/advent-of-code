defmodule Main do

  def main() do
    halls = "input-small.txt" |> parse_input
    #halls = "input-large.txt" |> parse_input
    #halls = "foo.txt" |> parse_input

    halls
    |> Enum.with_index
    |> Enum.map(fn {hall, i} ->
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

  #def find_reflection({rows, cols}), do: find_reflection(cols)

  def find_reflection({rows, cols}) do
    #print rows
    i = find_reflection(rows)
    if i do
      100 * i
    else
      find_reflection(cols)
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
    #dbg
    compare(part1, part2) == 1
  end

  def compare(part1, part2, diff \\ 0)
  def compare(_part1, _part2, 2), do: 2
  def compare([], [], diff), do: diff
  def compare([row1 | part1], [row2 | part2], diff) do
    new_diff = compare(row1, row2, diff)
    #dbg()
    compare(part1, part2, new_diff)
  end

  def compare(c1, c2, diff) when c1 == c2, do: diff
  def compare(_c1, _c2, diff), do: diff + 1

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn hall ->
      rows = String.split(hall, "\n") |> Enum.map(fn row -> row |> String.codepoints() end)
      cols = rows |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
      {rows, cols}
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> Main.p

# 400 - input-small.txt answer
# 31539 - input-large.txt answer
