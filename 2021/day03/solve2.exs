defmodule Main do
  def main() do
    rows = "input-large.txt" |> parse_input()
    calc(rows, 0, :o) * calc(rows, 0, :co2)
  end

  def calc([row], _, _), do: to_i(row)

  def calc(rows, col_idx, type) do
    keep =
      rows
      |> Enum.map(fn row -> Enum.at(row, col_idx) end)
      |> Enum.frequencies()
      |> zeroOrOne(type)

    rows
    |> Enum.filter(fn row -> Enum.at(row, col_idx) == keep end)
    |> calc(col_idx + 1, type)
  end

  def zeroOrOne(freq, :o), do: if(freq[1] >= freq[0], do: 1, else: 0)
  def zeroOrOne(freq, :co2), do: if(freq[0] <= freq[1], do: 0, else: 1)

  def to_i(col), do: col |> Enum.map(&Integer.to_string/1) |> Enum.join() |> String.to_integer(2)

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) end)
  end
end

Main.main() |> IO.puts()

# 230 - input-small.txt answer
# 7863147 - input-large.txt answer
