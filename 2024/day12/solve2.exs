defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    graph = parse_input("input-large.txt")

    graph
    |> gen_regions()
    |> Enum.map(fn region ->
      val = region |> Enum.take(1) |> hd() |> then(&graph[&1])
      boundary = gen_boundary(region, graph, val)
      MapSet.size(region) * count_sides(boundary, graph, val)
    end)
    |> Enum.sum()
  end

  def count_sides(points, graph, val) do
    [:n, :e, :s, :w]
    |> Enum.map(fn dir ->
      points
      |> Enum.filter(fn p -> get_adj(graph, p, dir) != val end)
      |> count_sides(dir)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def count_sides(points, dir) when dir in [:n, :s] do
    points
    |> Enum.group_by(fn {i, _j} -> i end)
    |> Map.values()
    |> Enum.map(fn row -> row |> Enum.map(fn {_i, j} -> j end) |> reduce_vals() end)
  end

  def count_sides(points, dir) when dir in [:e, :w] do
    points
    |> Enum.group_by(fn {_i, j} -> j end)
    |> Map.values()
    |> Enum.map(fn col -> col |> Enum.map(fn {i, _j} -> i end) |> reduce_vals() end)
  end

  def reduce_vals(vals) do
    vals
    |> Enum.sort()
    |> Enum.reduce([], fn n, acc ->
      if length(acc) == 0 do
        [n]
      else
        if n - hd(acc) == 1 do
          [n | tl(acc)]
        else
          [n | acc]
        end
      end
    end)
    |> Enum.count()
  end

  def gen_regions(graph) do
    Enum.reduce(Map.keys(graph), [], fn point, acc ->
      if Enum.any?(acc, fn region -> MapSet.member?(region, point) end) do
        acc
      else
        [dfs(graph, [point]) | acc]
      end
    end)
  end

  def gen_boundary(region, graph, val) do
    region
    |> Enum.filter(fn point ->
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, point) end)
      |> Enum.any?(fn p -> graph[p] != val end)
    end)
  end

  def get_adj(graph, point, :n), do: graph[add_points({-1, 0}, point)]
  def get_adj(graph, point, :s), do: graph[add_points({1, 0}, point)]
  def get_adj(graph, point, :e), do: graph[add_points({0, 1}, point)]
  def get_adj(graph, point, :w), do: graph[add_points({0, -1}, point)]

  def dfs(graph, nodes, visited \\ MapSet.new())
  def dfs(_graph, [], visited), do: visited

  def dfs(graph, [node | nodes], visited) do
    visited = MapSet.put(visited, node)
    val = graph[node]

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, node) end)
      |> Enum.filter(fn p -> graph[p] == val && !MapSet.member?(visited, p) end)

    dfs(graph, next_nodes ++ nodes, visited)
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
end

Main.main() |> IO.puts()

# 1206 - input-small.txt answer
# 893676 - input-large.txt answer
