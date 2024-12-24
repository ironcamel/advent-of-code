defmodule Main do
  @mod 16_777_216

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn n ->
      Enum.reduce(1..2000, n, fn _, acc -> evolve(acc) end)
    end)
    |> Enum.sum()
  end

  def evolve(n) do
    n = (n * 64) |> Bitwise.bxor(n) |> rem(@mod)
    n = n |> div(32) |> trunc() |> Bitwise.bxor(n) |> rem(@mod)
    (n * 2048) |> Bitwise.bxor(n) |> rem(@mod)
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end
end

Main.main() |> IO.puts()

# 37327623 - input-small.txt answer
# 15613157363 - input-large.txt answer
