defmodule Main do
  def main() do
    "input-large.txt" |> parse_input() |> Enum.map(&calc/1) |> Enum.sum()
  end

  def calc(bank, i2 \\ -12, val \\ [])
  def calc(_bank, 0, val), do: val |> Enum.join() |> String.to_integer()

  def calc(bank, i2, val) do
    dig = bank |> Enum.slice(0..i2//1) |> Enum.max()
    i = Enum.find_index(bank, fn x -> x == dig end)
    {_, bank} = Enum.split(bank, i + 1)
    calc(bank, i2 + 1, val ++ [dig])
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)
  end
end

Main.main() |> IO.puts()

# 3121910778619 - input-small.txt answer
# 169077317650774 - input-large.txt answer
