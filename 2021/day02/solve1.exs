defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.reduce({0, 0}, fn {dir, n}, acc -> move(acc, dir, n) end)
    |> then(fn {x, y} -> x * y end)
  end

  def move({x, y}, "forward", n), do: {x + n, y}
  def move({x, y}, "down", n), do: {x, y + n}
  def move({x, y}, "up", n), do: {x, y - n}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1))
    |> Enum.map(fn [dir, n] -> {dir, String.to_integer(n)} end)
  end
end

Main.main() |> IO.puts()

# 150 - input-small.txt answer
# 1990000 - input-large.txt answer
