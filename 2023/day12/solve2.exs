Mix.install [:memoize]

defmodule Main do
  use Memoize

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn {record, sizes} -> calc(record, sizes) end)
    |> Enum.sum()
  end

  defmemo calc([], []), do: 1
  defmemo calc([], _sizes), do: 0
  defmemo calc(record, []), do: if(Enum.any?(record, &(&1 == "#")), do: 0, else: 1)
  defmemo calc(record, sizes) do
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
    springs = springs |> String.replace(~r/\.+/, ".") |> List.duplicate(5) |> Enum.join("?") |> String.codepoints
    counts = counts |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.duplicate(5) |> List.flatten
    {springs, counts}
  end
end

Main.main() |> IO.puts()

# 525152 - input-small.txt answer
# 7139671893722 - input-large.txt answer
