defmodule Main do
  def main() do
    "input-large.txt" |> parse_input() |> rotate()
  end

  def rotate(_, cur \\ 50, count \\ 0)
  def rotate([], _cur, count), do: count

  def rotate([{dir, distance} | tail], cur, count) do
    val = if dir == "L", do: cur - distance, else: cur + distance

    inc =
      cond do
        val == 0 -> 1
        val < 0 and cur != 0 -> 1
        true -> 0
      end

    inc = inc + abs(div(val, 100))
    rotate(tail, Integer.mod(val, 100), count + inc)
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

# 6 - input-small.txt answer
# 6099 - input-large.txt answer
