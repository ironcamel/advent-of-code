defmodule Main do

  def main() do
    rows = "input-large.txt" |> parse_input
    #rows = "input-small.txt" |> parse_input
    #rows = "foo.txt" |> parse_input

    #process_row(hd rows)
    #rows |> Enum.map(fn {springs, _} -> score(springs) end)
    rows
    |> Enum.map(fn row -> process_row(row) end)
    |> Enum.sum()

  end

  def process_row({springs, counts}) do
    total = Enum.sum(counts)
    numh = Enum.count(springs, fn c -> c == "#" end)
    need = total - numh
    numq = Enum.count(springs, fn c -> c == "?" end)
    #dbg()
    0..(2 ** numq - 1)
    |> Enum.count(fn i ->
      b = Integer.to_string(i, 2)
      b = String.pad_leading(b, numq, "0") |> String.codepoints
      valid?(springs, b, need, counts)
    end)
  end

  def fill_springs(springs, b), do: fill_springs(springs, b, [])

  def fill_springs([], _, res), do: res

  def fill_springs([c | springs], [], res) do
    fill_springs(springs, [], res ++ [c])
  end

  def fill_springs(["?" | springs], [b0 | b], res) do
    c = if b0 == "1", do: "#", else: "."
    fill_springs(springs, b, res ++ [c])
  end

  def fill_springs([c | springs], b, res) do
    fill_springs(springs, b, res ++ [c])
  end

  def valid?(springs, b, need, counts) do
    if Enum.count(b, fn c -> c == "1" end) == need do
      filled = fill_springs(springs, b)
      #dbg
      score(filled) == counts
    else
      false
    end
  end

  def score(springs) do
    s = springs |> Enum.join()
    Regex.replace(~r/\.\.+/, s, ".")
    |> String.split(".", trim: true)
    |> Enum.map(&String.length/1)
    #|> dbg
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line)
      a = String.codepoints(a)
      b = b |> String.split(",") |> Enum.map(&String.to_integer/1)
      {a, b}
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> IO.inspect()

# 7221 - input-large.txt answer
