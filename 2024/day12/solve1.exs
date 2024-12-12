defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    graph = parse_input("input-large.txt")

    graph
    |> gen_regions()
    |> Enum.map(fn region ->
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
end

Main.main() |> IO.puts()

# 1930 - input-small.txt answer
# 1494342 - input-large.txt answer
