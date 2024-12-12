defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    #graph = parse_input("foo.txt")
    #graph = parse_input("foo2.txt")
    #graph = parse_input("input-small.txt")
    graph = parse_input("input-large.txt")

    regions = gen_regions(graph)

    regions
    |> Enum.map(fn region ->
      #boundary = gen_boundary(region, graph)
      area = MapSet.size(region)
      perimeter = calc_perimeter(region, graph)
      area * perimeter
    end)
    |> Enum.sum()
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

  def gen_boundary(region, graph) do
    val = region |> Enum.take(1) |> then(&graph[&1])
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

# 1930 - input-small.txt answer
# 1494342 - input-large.txt answer
