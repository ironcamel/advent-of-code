defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.flat_map(fn line -> String.split(line, " ") end)
    |> Enum.count(fn s -> String.length(s) in [2, 3, 4, 7] end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" | ") |> tl |> hd end)
  end
end

Main.main() |> IO.puts()

# 26 - input-small.txt answer
# 456 - input-large.txt answer
