defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn report ->
      for i <- 0..length(report) do
        List.delete_at(report, i)
      end
    end)
    |> Enum.filter(fn reports -> Enum.any?(reports, &check_report/1) end)
    |> Enum.count()
  end

  def check_report(report) do
    diffs =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x1, x2] -> x2 - x1 end)

    Enum.all?(diffs, fn diff -> abs(diff) >= 1 and abs(diff) <= 3 end) and
      (Enum.all?(diffs, &(&1 > 0)) or Enum.all?(diffs, &(&1 < 0)))
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

# 4 - input-small.txt answer
# 540 - input-large.txt answer
