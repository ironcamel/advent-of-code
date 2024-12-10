defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    map = "input-large.txt" |> parse_input()
    #map = "input-small.txt" |> parse_input()
    #map = "foo.txt" |> parse_input()
    #dbg map

    map
    |> Enum.filter(fn {_k, v} -> v == 0 end)
    |> Enum.map(fn {p, _v} -> search(map, [p]) end)
    |> Enum.map(fn paths -> length(paths) end)
    |> Enum.sum()
  end

  def search(map, points, path \\ [], paths \\ [])

  def search(_map, [], _path, paths) do
    paths
  end

  def search(map, [point | points], path, paths) do
    val = map[point]
    path = [point | path]

    if val == 9 do
      paths = [backtrack(map, path) | paths]
      search(map, points, path, paths)
    else
      @unit_circle
      |> Enum.map(fn dir -> add_points(point, dir) end)
      |> Enum.filter(fn p -> map[p] && map[p] == val + 1 end)
      #|> Enum.map(fn p -> search(map, p, path) end)
      |> then(fn next_points -> search(map, next_points ++ points, path, paths) end)
    end
  end

  def backtrack(map, path, result \\ MapSet.new(), prev_val \\ 10)

  def backtrack(_map, [], result, _prev_val) do
    result
  end

  def backtrack(map, [point | path], result, prev_val) do
    val = map[point]
    #dbg()
    cond do
      val + 1 == prev_val ->
        result = MapSet.put(result, point)
        backtrack(map, path, result, val)
      true ->
        backtrack(map, path, result, prev_val)
    end
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

# 81 - input-small.txt answer
# 1086 - input-large.txt answer
