defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> gen_grid()
    |> Enum.count(fn {_point, cnt} -> cnt > 1 end)
  end

  def gen_grid(vents, grid \\ %{})
  def gen_grid([], grid), do: grid

  def gen_grid([{{x1, y1}, {x2, y2}} | vents], grid) when x1 == x2 or y1 == y2 do
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

  def gen_grid([{{x1, y1}, {x2, y2}} | vents], grid) do
    {{x1, y1}, {x2, y2}} =
      if x1 < x2 do
        {{x1, y1}, {x2, y2}}
      else
        {{x2, y2}, {x1, y1}}
      end

    slope = (y2 - y1) / (x2 - x1)

    points =
      (x1 + 1)..x2
      |> Enum.reduce([{x1, y1}], fn x, acc ->
        {_prev_x, prev_y} = hd(acc)
        inc = if slope > 0, do: 1, else: -1
        [{x, prev_y + inc} | acc]
      end)

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
  end
end

Main.main() |> IO.puts()

# 12 - input-small.txt answer
# 21466 - input-large.txt answer
