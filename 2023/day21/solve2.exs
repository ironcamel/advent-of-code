defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    #grid = "input-small.txt" |> parse_input()
    grid = "input-large.txt" |> parse_input()
    start = grid |> Enum.find(fn {_k, v} -> v == "S" end) |> elem(0)
    {{max_i, max_j}, _} = Enum.max(grid)
    height = max_i + 1
    width = max_j + 1

    walk({grid, height, width}, start)
    |> Map.values()
    |> Enum.sum()
  end

  # x: 65, 65 + 131 and 65 + 2 * 131 
  # x: 65, 196, 327
  # y: 3787, 33976, 94315
  # x = 26501365 / 131 = 202300
  # 3787 + 15114 x + 15075 x^2, x = 202300
  # 616951804315987
  # https://www.wolframalpha.com/input?i=quadratic+regression+calculator+&assumption=%7B%22F%22%2C+%22QuadraticFitCalculator%22%2C+%22data3x%22%7D+-%3E%22%7B0%2C1%2C2%7D%22&assumption=%7B%22F%22%2C+%22QuadraticFitCalculator%22%2C+%22data3y%22%7D+-%3E%22%7B3787%2C+33976%2C+94315%7D%22
  # https://www.wolframalpha.com/input?i=3787+%2B+15114+x+%2B+15075+x%5E2%2C+x+%3D+202300
  def walk(_grid, _points, vals, 65), do: vals # 3787
  #def walk(_grid, _points, vals, 196), do: vals # 33976
  #def walk(_grid, _points, vals, 327), do: vals # 94315

  def walk(data, point) do
    walk(data, [point], %{}, 0)
  end

  def walk(data, points, vals, cnt) do
    zeros = points |> Enum.map(fn point -> {point, 0} end) |> Map.new
    vals = Map.merge(vals, zeros)
    ones =
      points
      |> Enum.flat_map(fn point -> get_new_points(data, point) end)
      |> Enum.map(fn point -> {point, 1} end)
      |> Map.new

    vals = Map.merge(vals, ones)

    new_sources = vals |> Enum.filter(fn {_k, v} -> v == 1 end) |> Enum.map(&elem(&1, 0))
    walk(data, new_sources, vals, cnt + 1)
  end

  def get_new_points({grid, height, width}, point) do
    @unit_circle
    |> Enum.map(fn delta -> point |> add_points(delta) end)
    |> Enum.filter(fn p -> grid[fix_point(p, height, width)] != "#" end)
  end

  def fix_point({i, j}, height, width) do
    new_i = Integer.mod(i, height)
    new_j = Integer.mod(j, width)
    {new_i, new_j}
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def print(grid) do
    {{max_i, max_j}, _} = Enum.max(grid)
    for i <- 0..max_i do
      for j <- 0..max_j do
        IO.write(grid[{i, j}])
      end
      IO.puts ""
    end
    grid
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
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

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p

# 3748
