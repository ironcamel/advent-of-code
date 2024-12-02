defmodule Main do
  def main() do
    [list1, list2] = parse_input("input-large.txt")

    Enum.reduce(list1, 0, fn n, acc ->
      acc + Enum.count(list2, &(&1 == n)) * n
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end

Main.main() |> IO.puts()

# 31 - input-small.txt answer
# 19437052 - input-large.txt answer
