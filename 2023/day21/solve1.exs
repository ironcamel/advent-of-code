defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    #grid = "input-small.txt" |> parse_input()
    grid = "input-large.txt" |> parse_input()
    start = grid |> Enum.find(fn {_k, v} -> v == "S" end) |> elem(0)

    walk(grid, start)
    |> Map.values()
    |> Enum.sum()
  end

  def walk(_grid, _points, vals, 64), do: vals

  def walk(grid, point) do
    walk(grid, [point], %{}, 0)
  end

  def walk(grid, points, vals, cnt) do
    zeros = points |> Enum.map(fn point -> {point, 0} end) |> Map.new
    vals = Map.merge(vals, zeros)
    ones =
      points
      |> Enum.flat_map(fn point -> get_new_points(grid, point) end)
      |> Enum.map(fn point -> {point, 1} end)
      |> Map.new

    vals = Map.merge(vals, ones)

    new_sources = vals |> Enum.filter(fn {_k, v} -> v == 1 end) |> Enum.map(&elem(&1, 0))
    walk(grid, new_sources, vals, cnt + 1)
  end

  def get_new_points(grid, point) do
      @unit_circle
      |> Enum.map(fn delta -> add_points(point, delta) end)
      |> Enum.filter(fn p -> grid[p] && grid[p] != "#" end)
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
