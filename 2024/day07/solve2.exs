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
  def check(ans, vals, acc), do: Enum.any?([:add, :mul, :con], &check(ans, vals, acc, &1))
  def check(ans, [val | vals], acc, :add), do: check(ans, vals, acc + val)
  def check(ans, [val | vals], acc, :mul), do: check(ans, vals, acc * val)

  def check(ans, [val | vals], acc, :con) do
    acc = String.to_integer(Integer.to_string(acc) <> Integer.to_string(val))
    check(ans, vals, acc)
  end

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

# 11387 - input-small.txt answer
# 106016735664498 - input-large.txt answer
