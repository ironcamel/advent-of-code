defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @unit_circle [@north, @south, @east, @west]

  def main() do
    bytes = parse_input("input-large.txt")
    max_i = bytes |> Enum.map(fn {i, _j} -> i end) |> Enum.max()
    max_j = bytes |> Enum.map(fn {_i, j} -> j end) |> Enum.max()
    target = {max_i, max_j}
    {bytes1, bytes2} = Enum.split(bytes, 1024)
    #{bytes1, bytes2} = Enum.split(bytes, 2898)
    graph = bytes1 |> Enum.map(fn p -> {p, "#"} end) |> Map.new()
    process(graph, bytes2, target)
  end

  def process(graph, [{i, j} = point | points], target) do
    graph = Map.put(graph, point, "#")

    if bfs(graph, [{0, 0}], target) == :no_exit do
      "#{j},#{i}"
    else
      process(graph, points, target)
    end
  end

  def bfs(graph, nodes, target, visited \\ MapSet.new())
  def bfs(_graph, [], _target, _visited), do: :no_exit
  def bfs(_graph, [pos | _nodes], target, _visited) when pos == target, do: :found_exit

  def bfs(graph, [node | nodes], target, visited) do
    if MapSet.member?(visited, node) do
      bfs2(graph, nodes, target, visited)
    else
      bfs2(graph, [node | nodes], target, visited)
    end
  end

  def bfs2(graph, [node | nodes], {max_i, max_j} = target, visited) do
    visited = MapSet.put(visited, node)

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, node) end)
      |> Enum.filter(fn {i, j} = p ->
        not MapSet.member?(visited, p) and graph[p] != "#" and i in 0..max_i and j in 0..max_j
      end)

    bfs(graph, nodes ++ next_nodes, target, visited)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [j, i] -> {i, j} end)
  end
end

Main.main() |> IO.puts()

# 6,1 - input-small.txt answer
# 52,32 - input-large.txt answer
