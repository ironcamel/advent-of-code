defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.filter(fn {ans, vals} -> check(ans, vals) end)
    |> Enum.map(fn {ans, _vals} -> ans end)
    |> Enum.sum()
  end

  def check(ans, [val | vals]), do: check(ans, vals, val)
  def check(ans, [], acc), do: acc == ans
  def check(ans, vals, acc), do: check(ans, vals, acc, :add) or check(ans, vals, acc, :mul)
  def check(ans, [val | vals], acc, :add), do: check(ans, vals, acc + val)
  def check(ans, [val | vals], acc, :mul), do: check(ans, vals, acc * val)

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [ans, vals] = String.split(line, ": ")
      vals = vals |> String.split() |> Enum.map(&String.to_integer/1)
      {String.to_integer(ans), vals}
    end)
  end
end

Main.main() |> IO.puts()

# 3749 - input-small.txt answer
# 12940396350192 - input-large.txt answer
