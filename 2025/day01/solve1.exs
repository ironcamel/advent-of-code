defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.reduce([50], fn {dir, distance}, acc = [cur | _] ->
      val = if dir == "L", do: cur - distance, else: cur + distance
      [Integer.mod(val, 100) | acc]
    end)
    |> Enum.count(fn x -> x == 0 end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      {dir, val} = String.split_at(s, 1)
      {dir, String.to_integer(val)}
    end)
  end
end

Main.main() |> IO.puts()

# 3 - input-small.txt answer
# 999 - input-large.txt answer
