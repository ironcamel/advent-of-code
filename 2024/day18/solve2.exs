defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @unit_circle [@north, @south, @east, @west]
  #@max_i 6
  @max_i 70
  @max_j @max_i
  @range_i 0..@max_i
  @range_j 0..@max_j
  @target {@max_i, @max_i}

  def main() do
    
    bytes = parse_input("input-large.txt")
    #bytes = parse_input("input-small.txt")
    {bytes1, bytes2} = Enum.split(bytes, 1024)
    #{bytes1, bytes2} = Enum.split(bytes, 12)
    graph = bytes1 |> Enum.map(fn p -> {p, "#"} end) |> Map.new()
    process(graph, bytes2)
  end

  def process(graph, [{i, j} = point | points]) do
    graph = Map.put(graph, point, "#")
    if bfs(graph, [{{0, 0}, 0}], @target) == -1 do
      "#{j},#{i}"
    else
      process(graph, points)
    end
  end

  def bfs(graph, nodes, target, visited \\ MapSet.new())
  def bfs(_graph, [], _target, _visited), do: -1

  def bfs(_graph, [{pos, depth} | _nodes], target, _visited) when pos == target, do: depth

  def bfs(graph, [{pos, _depth} = node | nodes], target, visited) do
    if MapSet.member?(visited, pos) do
      bfs2(graph, nodes, target, visited)
    else
      bfs2(graph, [node | nodes], target, visited)
    end
  end

  def bfs2(graph, [{pos, depth} | nodes], target, visited) do
    #dbg pos: pos, depth: depth, visited: visited, nodes: nodes
    visited = MapSet.put(visited, pos)

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, pos) end)
      |> Enum.filter(fn {i, j} = p ->
        not MapSet.member?(visited, p)
        and graph[p] != "#"
        and i in @range_i and j in @range_j
      end)
      |> Enum.map(fn pos -> {pos, depth + 1} end)

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
