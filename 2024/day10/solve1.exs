defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    map = "input-large.txt" |> parse_input()
    #map = "input-small.txt" |> parse_input()
    #map = "foo.txt" |> parse_input()
    #dbg map

    map
    |> Enum.filter(fn {_k, v} -> v == 0 end)
    |> Enum.map(fn {p, _v} -> dfs(map, [p]) end)
    |> Enum.sum()
  end

  def dfs(map, points, visited \\ MapSet.new())

  def dfs(map, [], visited) do
    Enum.count(visited, fn p -> map[p] == 9 end)
  end

  def dfs(map, [point | points], visited) do
    visited = MapSet.put(visited, point)
    val = map[point]

    @unit_circle
    |> Enum.map(fn dir -> add_points(point, dir) end)
    |> Enum.filter(fn p ->
      map[p] && map[p] == val + 1 && not MapSet.member?(visited, p)
    end)
    |> then(fn next_points -> dfs(map, next_points ++ points, visited) end)
  end


  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

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
      |> Enum.map(fn {val, j} -> {{i, j}, String.to_integer(val)} end)
    end)
    |> Map.new()
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 36 - input-small.txt answer
# 489 - input-large.txt answer
