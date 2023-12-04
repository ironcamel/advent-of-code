defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input
    |> Enum.map(fn {win_set, my_nums} ->
      cnt = Enum.count(my_nums, fn num -> MapSet.member?(win_set, num) end)
      if cnt == 0, do: 0, else: 2 ** (cnt - 1)
    end)
    |> Enum.sum()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, winners, my_nums] = String.split(line, [":", "|"])
      win_set = winners |> String.split() |> MapSet.new()
      {win_set, String.split(my_nums)}
    end)
  end
end

Main.main() |> IO.puts()

# 13 - input-small.txt answer
# 23678 - input-large.txt answer
