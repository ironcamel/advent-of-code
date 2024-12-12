defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    #graph = parse_input("foo.txt")
    #graph = parse_input("foo2.txt")
    #graph = parse_input("input-small.txt")
    graph = parse_input("input-large.txt")

    # iterate over boundary
    # store top, bottom, left, and right edges
    # merge edges together

    # AAA
    # AAA
    # AA
    #
    # 1 top edge, 1 left edge, 2 bottom edges, 2 right edges

    regions = gen_regions(graph)

    regions
    |> Enum.map(fn region ->
      val = region |> Enum.take(1) |> hd() |> then(&graph[&1])
      #dbg(val)
      boundary = gen_boundary(region, graph, val)
      area = MapSet.size(region)
      #perimeter = calc_perimeter(region, graph)
      #area * perimeter
      sides = count_sides(boundary, graph, val)
      area * sides
    end)
    |> Enum.sum()
  end

  def count_sides(points, graph, val) do
    #{min_i, max_i} = points |> Enum.map(fn {i, _j} -> i end) |> Enum.min_max()
    #{min_j, max_j} = points |> Enum.map(fn {_i, j} -> j end) |> Enum.min_max()

    [:n, :e, :s, :w]
    |> Enum.map(fn dir -> count_sides(points, graph, val, dir) end)
    |> Enum.sum()
  end

  def count_sides(points, graph, val, dir) when dir in [:n, :s] do
    points
    |> Enum.filter(fn p -> get_dir(graph, p, dir) != val end)
    |> Enum.group_by(fn {i, _j} -> i end)
    |> Map.values()
    |> Enum.map(fn row -> row |> Enum.map(fn {_i, j} -> j end) |> reduce_vals() end)
    |> Enum.sum()
  end

  def count_sides(points, graph, val, dir) do
    points
    |> Enum.filter(fn p -> get_dir(graph, p, dir) != val end)
    |> Enum.group_by(fn {_i, j} -> j end)
    |> Map.values()
    |> Enum.map(fn col -> col |> Enum.map(fn {i, _j} -> i end) |> reduce_vals() end)
    |> Enum.sum()
  end

  def reduce_vals(vals) do
    #dbg()
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

  def calc_perimeter(boundary, graph) do
    val = boundary |> Enum.take(1) |> hd() |> then(&graph[&1])

    boundary
    |> Enum.map(fn point ->
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, point) end)
      |> Enum.count(fn p -> graph[p] != val end)
    end)
    |> Enum.sum()
  end

  def get_dir(graph, point, :n), do: graph[add_points({-1, 0}, point)]
  def get_dir(graph, point, :s), do: graph[add_points({1, 0}, point)]
  def get_dir(graph, point, :e), do: graph[add_points({0, 1}, point)]
  def get_dir(graph, point, :w), do: graph[add_points({0, -1}, point)]

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

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 1206 - input-small.txt answer
# 893676 - input-large.txt answer
