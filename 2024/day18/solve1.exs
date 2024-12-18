defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @unit_circle [@north, @south, @east, @west]
  @max_i 70
  @max_j @max_i
  @target {@max_i, @max_j}

  def main() do
    "input-large.txt" |> parse_input() |> bfs([{{0, 0}, 0}])
  end

  def bfs(graph, nodes, visited \\ MapSet.new())
  def bfs(_graph, [{pos, depth} | _nodes], _visited) when pos == @target, do: depth

  def bfs(graph, [{pos, _depth} = node | nodes], visited) do
    if MapSet.member?(visited, pos) do
      bfs2(graph, nodes, visited)
    else
      bfs2(graph, [node | nodes], visited)
    end
  end

  def bfs2(graph, [{pos, depth} | nodes], visited) do
    visited = MapSet.put(visited, pos)

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, pos) end)
      |> Enum.filter(fn {i, j} = p ->
        not MapSet.member?(visited, p) and graph[p] != "#" and i in 0..@max_i and j in 0..@max_j
      end)
      |> Enum.map(fn pos -> {pos, depth + 1} end)

    bfs(graph, nodes ++ next_nodes, visited)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.take(1024)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [j, i] -> {{i, j}, "#"} end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 22 - input-small.txt answer
# 298 - input-large.txt answer
