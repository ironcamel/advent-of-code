defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {x1, x2} -> abs(x1 - x2) end)
    |> Enum.sum()
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

# 11 - input-small.txt answer
# 1882714 - input-large.txt answer
