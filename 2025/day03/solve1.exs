defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn bank ->
      dig1 = bank |> Enum.slice(0..-2//1) |> Enum.max()
      i = Enum.find_index(bank, fn x -> x == dig1 end)
      dig2 = bank |> Enum.slice(i + 1, 222) |> Enum.max()
      String.to_integer(dig1 <> dig2)
    end)
    |> Enum.sum()
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)
  end
end

Main.main() |> IO.puts()

# 357 - input-small.txt answer
# 17166 - input-large.txt answer
