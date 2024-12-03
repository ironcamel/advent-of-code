defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn report ->
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x1, x2] -> x2 - x1 end)
    end)
    |> Enum.filter(fn diffs ->
      Enum.all?(diffs, fn diff -> abs(diff) >= 1 and abs(diff) <= 3 end) and
        (Enum.all?(diffs, &(&1 > 0)) or Enum.all?(diffs, &(&1 < 0)))
    end)
    |> Enum.count()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  end
end

Main.main() |> IO.puts()

# 2 - input-small.txt answer
# 486 - input-large.txt answer
