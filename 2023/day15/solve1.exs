defmodule Main do
  def main() do
    "input-large.txt" |> parse_input() |> Enum.map(&hash/1) |> Enum.sum()
  end

  def hash(s) do
    s |> String.to_charlist() |> Enum.reduce(0, fn c, acc -> rem((acc + c) * 17, 256) end)
  end

  def parse_input(path), do: path |> File.read!() |> String.trim() |> String.split(",")
end

Main.main() |> IO.puts()

# 1320 - input-small.txt answer
# 503154 - input-large.txt answer
