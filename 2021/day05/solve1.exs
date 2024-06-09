defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> gen_grid()
    |> Enum.count(fn {_point, cnt} -> cnt > 1 end)
  end

  def gen_grid(vents, grid \\ %{})
  def gen_grid([], grid), do: grid

  def gen_grid([{{x1, y1}, {x2, y2}} | vents], grid) do
    points =
      if y1 == y2 do
        x1..x2
        |> Enum.map(fn x -> {x, y1} end)
      else
        y1..y2
        |> Enum.map(fn y -> {x1, y} end)
      end

    grid =
      Enum.reduce(points, grid, fn point, acc ->
        Map.put(acc, point, Map.get(acc, point, 0) + 1)
      end)

    gen_grid(vents, grid)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [x1, y1, x2, y2] =
        ~r/(\d+),(\d+) -> (\d+),(\d+)/
        |> Regex.run(line)
        |> tl
        |> Enum.map(&String.to_integer/1)

      {{x1, y1}, {x2, y2}}
    end)
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} -> x1 == x2 or y1 == y2 end)
  end
end

Main.main() |> IO.puts()

# 5 - input-small.txt answer
# 6572 - input-large.txt answer
