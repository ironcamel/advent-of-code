defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.reduce({0, 0, 0}, fn {dir, n}, acc -> move(acc, dir, n) end)
    |> then(fn {x, y, _} -> x * y end)
  end

  def move({x, y, aim}, "forward", n), do: {x + n, y + aim * n, aim}
  def move({x, y, aim}, "down", n), do: {x, y, aim + n}
  def move({x, y, aim}, "up", n), do: {x, y, aim - n}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1))
    |> Enum.map(fn [dir, n] -> {dir, String.to_integer(n)} end)
  end
end

Main.main() |> IO.puts()

# 900 - input-small.txt answer
# 1975421260 - input-large.txt answer
