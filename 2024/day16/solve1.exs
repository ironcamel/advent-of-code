Mix.install([:heap])

defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @left_of %{@north => @west, @south => @east, @east => @north, @west => @south}
  @right_of %{@north => @east, @south => @west, @east => @south, @west => @north}

  def main() do
    grid = parse_input("input-large.txt")
    {start, _} = Enum.find(grid, fn {_k, v} -> v == "S" end)
    {target, _} = Enum.find(grid, fn {_k, v} -> v == "E" end)
    dijkstra(grid, start, target)
  end

  def dijkstra(grid, start, target) do
    start_node = {start, @east}
    dist = %{start_node => 0}
    visited = MapSet.new()
    nodes = Heap.new() |> Heap.push({0, start_node})
    dijkstra(grid, nodes, visited, dist, target)
  end

  def dijkstra(grid, nodes, visited, dist, target) do
    {score, {pos, dir} = node} = Heap.root(nodes)

    if pos == target do
      score
    else
      nodes = Heap.pop(nodes)
      visited = MapSet.put(visited, node)

      neighbors =
        [
          {{add_points(pos, dir), dir}, 1},
          {{pos, @left_of[dir]}, 1000},
          {{pos, @right_of[dir]}, 1000}
        ]
        |> Enum.reject(fn {{pos, _dir} = node, _cost} ->
          MapSet.member?(visited, node) or grid[pos] == "#"
        end)

      dist = update_dist(node, dist, neighbors)

      neighbors =
        neighbors
        |> Enum.map(fn {node, _cost} -> node end)
        |> Enum.reduce(nodes, fn node, acc ->
          Heap.push(acc, {dist[node], node})
        end)

      dijkstra(grid, neighbors, visited, dist, target)
    end
  end

  def update_dist(node1, dist, neighbors) do
    Enum.reduce(neighbors, dist, fn {node2, cost}, acc ->
      val = acc[node1] + cost

      if !acc[node2] or val < acc[node2] do
        Map.put(acc, node2, val)
      else
        acc
      end
    end)
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
      |> Enum.reject(fn {val, _j} -> val == "." end)
      |> Enum.map(fn {val, j} -> {{i, j}, val} end)
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 7036 - input-small.txt answer
# 11048 - input-small2.txt answer
# 79404 - input-large.txt answer
