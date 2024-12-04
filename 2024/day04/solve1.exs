defmodule Main do
  @unit_circle [{-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}]

  def main() do
    grid = parse_input("input-large.txt")

    grid
    |> Enum.filter(fn {_point, val} -> val == "X" end)
    |> Enum.map(fn {point, _val} ->
      Enum.count(@unit_circle, fn dir -> check_point(grid, point, dir) end)
    end)
    |> Enum.sum()
  end

  def add_points({i1, j1}, {i2, j2}, scale), do: {i1 + i2 * scale, j1 + j2 * scale}

  def check_point(grid, point, dir) do
    Enum.map(1..3, fn scale -> grid[add_points(point, dir, scale)] end) == ["M", "A", "S"]
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {val, j} -> {{i, j}, val} end)
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 18 - input-small.txt answer
# 2569 - input-large.txt answer
