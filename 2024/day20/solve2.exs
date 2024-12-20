defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @unit_circle [@north, @south, @east, @west]

  def main() do
    #graph = parse_input("input-small.txt")
    graph = parse_input("input-large.txt")
    start = graph |> Enum.find(fn {_p, v} -> v == "S" end) |> elem(0)
    target = graph |> Enum.find(fn {_p, v} -> v == "E" end) |> elem(0)
    dbg start
    dbg target
    graph = graph |> Map.put(start, ".") |> Map.put(target, ".")

    dist_from_end = bfs(graph, target)
    dist_from_start = bfs(graph, start)

    search(Map.keys(dist_from_end), dist_from_end, %{})
    |> Map.values()
    #|> Enum.filter(fn n -> n >= 50 end)
    #|> Enum.frequencies()
    |> Enum.count(fn n -> n >= 100 end)
  end

  def search([], _dist_from_end, cheat_dist), do: cheat_dist

  def search([point | points], dist_from_end, cheat_dist) do
    cheat_dist =
      points_in_radius(point, 20)
      |> Enum.filter(fn p -> dist_from_end[p] end)
      |> Enum.reduce(cheat_dist, fn p, acc ->
        old_savings = Map.get(acc, {point, p}, 0)
        #dbg taxi_dist: taxi_dist(point, p)
        #savings = dist_from_end[point] - dist_from_end[p] + taxi_dist(point, p)
        savings = dist_from_end[point] - dist_from_end[p] - taxi_dist(point, p)
        if point in [{3, 1}] do
          #dbg savings: savings, old_value: old_savings
        end
        if savings > old_savings do
          Map.put(acc, {point, p}, savings)
        else
          acc
        end
      end)

    search(points, dist_from_end, cheat_dist)
  end

  def points_in_radius(p, n) do
    for i <- -n..n, j <- -n..n, abs(i) + abs(j) <= n, {i, j} != {0, 0} do
      add_points(p, {i, j})
    end

    #@unit_circle
    #|> Enum.map(fn p1 ->
    #  p |> add_points(p1) |> add_points(p1)
    #end)
  end

  def taxi_dist({i1, j1}, {i2, j2}), do: abs(i1 - i2) + abs(j1 - j2)

  #def bfs(graph, nodes, target, visited \\ %{}, dist \\ %{})

  def bfs(graph, start) do
    bfs(graph, [start], %{}, %{start => 0})
  end

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

Main.main() |> Main.p()

# 1007186 - input-large.txt answer
