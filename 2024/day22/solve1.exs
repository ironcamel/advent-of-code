defmodule Main do
  def main() do
     "input-large.txt"
    #"input-small.txt"
    |> parse_input()
    |> Enum.map(fn n ->
      Enum.reduce(1..2000, n, fn _, acc ->
        evolve(acc)
      end)
    end)
    |> Enum.sum()
  end

  def evolve(n) do
    n = n * 64 |> Bitwise.bxor(n) |> rem(16777216)
    n = n |> div(32) |> trunc() |> Bitwise.bxor(n) |> rem(16777216)
    n * 2048 |> Bitwise.bxor(n) |> rem(16777216)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 37327623 - input-small.txt answer
# 15613157363 - input-large.txt answer
