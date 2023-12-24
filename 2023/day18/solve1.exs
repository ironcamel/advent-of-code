# This uses https://en.wikipedia.org/wiki/Shoelace_formula
defmodule Main do
  def main() do
    {vertices, perimeter} = "input-large.txt" |> parse_input()

    vertices
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [{x1, y1}, {x2, y2}], acc -> acc + (x1 - x2) * (y1 + y2) / 2 end)
    |> then(fn area -> abs(area) + perimeter / 2 + 1 end)
  end

  def parse_input(path) do
    {vertices, perimeter} =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.reduce({[{0, 0}], 0}, fn line, acc ->
        {vertices, perimeter} = acc
        [dir, cnt, _color] = String.split(line)
        cnt = String.to_integer(cnt)
        point = hd(vertices)
        {[vertex_for(point, cnt, dir) | vertices], perimeter + cnt}
      end)

    min_y = vertices |> Enum.map(fn {_x, y} -> y end) |> Enum.min()
    delta_y = if min_y < 0, do: abs(min_y), else: 0
    vertices = Enum.map(vertices, fn {x, y} -> {x, y + delta_y} end)
    {vertices, perimeter}
  end

  def vertex_for(point, cnt, dir) do
    {unit_x, unit_y} =
      case dir do
        "R" -> {1, 0}
        "L" -> {-1, 0}
        "U" -> {0, 1}
        "D" -> {0, -1}
      end

    add_points(point, {unit_x * cnt, unit_y * cnt})
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}
end

Main.main() |> IO.puts()

# 62 - input-small.txt answer
# 108909 - input-large.txt answer
