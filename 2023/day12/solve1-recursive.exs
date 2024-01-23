defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn {record, sizes} -> calc(record, sizes) end)
    |> Enum.sum()
  end

  def calc([], []), do: 1
  def calc([], _sizes), do: 0
  def calc(record, []), do: if(Enum.any?(record, &(&1 == "#")), do: 0, else: 1)

  def calc(record, sizes) do
    case hd(record) do
      "#" -> handle_hash(record, sizes)
      "." -> calc(tl(record), sizes)
      "?" -> calc(tl(record), sizes) + handle_hash(record, sizes)
    end
  end

  def handle_hash(record, [size | _sizes]) when length(record) < size, do: 0

  def handle_hash(record, [size | sizes]) do
    check_vals = record |> Enum.take(size) |> Enum.all?(&(&1 in ["#", "?"]))
    has_sep = Enum.at(record, size) in ["?", ".", nil]

    if check_vals and has_sep do
      calc(record |> Enum.split(size + 1) |> elem(1), sizes)
    else
      0
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> parse_line(line) end)
  end

  def parse_line(line) do
    [springs, counts] = String.split(line)
    springs = springs |> String.replace(~r/\.+/, ".") |> String.codepoints()
    counts = counts |> String.split(",") |> Enum.map(&String.to_integer/1)
    {springs, counts}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> IO.inspect()

# 21 input-small.txt answer
# 7221 - input-large.txt answer
