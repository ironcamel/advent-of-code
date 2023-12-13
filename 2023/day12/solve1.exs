defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(&process_row(&1))
    |> Enum.sum()
  end

  def process_row({springs, counts}) do
    total = Enum.sum(counts)
    numq = Enum.count(springs, fn c -> c == "?" end)
    numh = Enum.count(springs, fn c -> c == "#" end)
    need = total - numh

    0..(2 ** numq - 1)
    |> Enum.count(fn i ->
      bits = Integer.to_string(i, 2) |> String.pad_leading(numq, "0") |> String.codepoints()
      valid?(springs, bits, counts, need)
    end)
  end

  def fill_springs(springs, bits, res \\ [])

  def fill_springs([], _, res), do: res

  def fill_springs(["?" | springs], [bit | bits], res) do
    c = if bit == "1", do: "#", else: "."
    fill_springs(springs, bits, res ++ [c])
  end

  def fill_springs([c | springs], bits, res) do
    fill_springs(springs, bits, res ++ [c])
  end

  def valid?(springs, bits, counts, need) do
    if Enum.count(bits, fn c -> c == "1" end) == need do
      springs |> fill_springs(bits) |> count_springs() == counts
    else
      false
    end
  end

  def count_springs(springs) do
    Regex.scan(~r/#+/, Enum.join(springs))
    |> List.flatten()
    |> Enum.map(&String.length/1)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [springs, counts] = String.split(line)
      springs = String.codepoints(springs)
      counts = counts |> String.split(",") |> Enum.map(&String.to_integer/1)
      {springs, counts}
    end)
  end
end

Main.main() |> IO.puts()

# 21 input-small.txt answer
# 7221 - input-large.txt answer
