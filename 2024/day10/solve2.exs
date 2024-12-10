defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    map = parse_input("input-large.txt")

    map
    |> Enum.filter(fn {_p, v} -> v == 0 end)
    |> Enum.map(fn {p, _v} -> dfs(map, [p], 0) end)
    |> Enum.sum()
  end

  def dfs(_map, [], paths), do: paths

  def dfs(map, [point | points], paths) do
    val = map[point]
    paths = if val == 9, do: paths + 1, else: paths

    @unit_circle
    |> Enum.map(fn dir -> add_points(point, dir) end)
    |> Enum.filter(fn p -> map[p] && map[p] == val + 1 end)
    |> then(fn next_points -> dfs(map, next_points ++ points, paths) end)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {val, j} -> {{i, j}, String.to_integer(val)} end)
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 81 - input-small.txt answer
# 1086 - input-large.txt answer
