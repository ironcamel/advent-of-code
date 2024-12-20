defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @unit_circle [@north, @south, @east, @west]

  def main() do
    graph = parse_input("input-large.txt")
    start = graph |> Enum.find(fn {_p, v} -> v == "S" end) |> elem(0)
    target = graph |> Enum.find(fn {_p, v} -> v == "E" end) |> elem(0)
    graph = graph |> Map.put(start, ".") |> Map.put(target, ".")
    dist_from_end = bfs(graph, target)

    dist_from_end
    |> Map.keys()
    |> calc_savings(dist_from_end, %{})
    |> Map.values()
    |> Enum.count(fn n -> n >= 100 end)
  end

  def calc_savings([], _dist_from_end, savings_map), do: savings_map

  def calc_savings([point | points], dist_from_end, savings_map) do
    savings_map =
      point
      |> points_around()
      |> Enum.filter(fn p -> dist_from_end[p] end)
      |> Enum.reduce(savings_map, fn p, acc ->
        old_savings = Map.get(acc, {point, p}, 0)
        savings = dist_from_end[point] - dist_from_end[p] - 2

        if savings > old_savings do
          Map.put(acc, {point, p}, savings)
        else
          acc
        end
      end)

    calc_savings(points, dist_from_end, savings_map)
  end

  def points_around(p) do
    Enum.map(@unit_circle, fn p1 -> p |> add_points(p1) |> add_points(p1) end)
  end

  def bfs(graph, start), do: bfs(graph, [start], %{}, %{start => 0})
  def bfs(_graph, [], _visited, dist), do: dist

  def bfs(graph, [pos | nodes], visited, dist) when is_map_key(visited, pos) do
    bfs(graph, nodes, visited, dist)
  end

  def bfs(graph, [pos | nodes], visited, dist) do
    visited = Map.put(visited, pos, true)
    new_dist = dist[pos] + 1

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, pos) end)
      |> Enum.reject(fn p -> visited[p] || graph[p] == "#" end)

    dist =
      Enum.reduce(next_nodes, dist, fn next_pos, acc ->
        Map.put(acc, next_pos, new_dist)
      end)

    bfs(graph, nodes ++ next_nodes, visited, dist)
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
      |> Enum.map(fn {val, j} -> {{i, j}, val} end)
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 1363 - input-large.txt answer
