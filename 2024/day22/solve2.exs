defmodule Main do
  @mod 16_777_216

  def main() do
    numbers = parse_input("input-large.txt")

    buyers =
      numbers
      |> Enum.map(fn n ->
        1..2000
        |> Enum.reduce([n], fn _, acc -> [acc |> hd() |> evolve() | acc] end)
        |> Enum.reverse()
        |> Enum.map(fn n -> rem(n, 10) end)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> {b, b - a} end)
        |> Enum.chunk_every(4, 1, :discard)
        |> Enum.reverse()
        |> Enum.map(fn [{_, c1}, {_, c2}, {_, c3}, {p, c4}] -> {{c1, c2, c3, c4}, p} end)
        |> Map.new()
      end)

    buyers
    |> Enum.flat_map(fn prices -> Map.keys(prices) end)
    |> Enum.uniq()
    |> Enum.map(fn changes ->
      buyers
      |> Enum.map(fn prices -> prices[changes] || 0 end)
      |> Enum.sum()
    end)
    |> Enum.max()
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

# 23 - input-small2.txt answer
# 1784 - input-large.txt answer
