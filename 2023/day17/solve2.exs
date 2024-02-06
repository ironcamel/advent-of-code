Mix.install([:heap])

defmodule Main do
  @east {0, 1}
  @west {0, -1}
  @south {1, 0}
  @north {-1, 0}
  @left_of %{@north => @west, @south => @east, @east => @north, @west => @south}
  @right_of %{@north => @east, @south => @west, @east => @south, @west => @north}

  def main() do
    grid = "input-large.txt" |> parse_input()
    {target, _} = Enum.max(grid)

    dijkstra(grid)
    |> Enum.filter(fn {{n, _, steps}, _val} -> n == target and steps >= 4 end)
    |> Enum.map(fn {_node, val} -> val end)
    |> Enum.min()
  end

  def dijkstra(grid) do
    start_node1 = {{0, 0}, @east, 0}
    start_node2 = {{0, 0}, @south, 0}
    dist = %{start_node1 => 0, start_node2 => 0}
    prev = %{}
    visited = MapSet.new()
    nodes = Heap.new() |> Heap.push({0, start_node1}) |> Heap.push({0, start_node2})
    dijkstra(grid, nodes, visited, dist, prev)
  end

  def dijkstra(grid, nodes, visited, dist, prev) do
    if Heap.empty?(nodes) do
      dist
    else
      {_, node} = Heap.root(nodes)
      nodes = Heap.pop(nodes)

      if MapSet.member?(visited, node) do
        dijkstra(grid, nodes, visited, dist, prev)
      else
        visited = MapSet.put(visited, node)
        neighbors = get_neighbors(grid, node)
        {dist, prev} = update_dist(grid, node, visited, dist, prev, neighbors)

        nodes =
          Enum.reduce(neighbors, nodes, fn node, acc ->
            Heap.push(acc, {dist[node], node})
          end)

        dijkstra(grid, nodes, visited, dist, prev)
      end
    end
  end

  def update_dist(_grid, _node, _nodes, dist, prev, []), do: {dist, prev}

  def update_dist(grid, node1, visited, dist, prev, [node2 | neighbors]) do
    val = dist[node1] + grid[elem(node2, 0)]

    if val < dist[node2] do
      dist = Map.put(dist, node2, val)
      prev = Map.put(prev, node2, node1)
      update_dist(grid, node1, visited, dist, prev, neighbors)
    else
      update_dist(grid, node1, visited, dist, prev, neighbors)
    end
  end

  def get_neighbors(grid, {point, dir, steps}) do
    if steps >= 4 do
      left = @left_of[dir]
      right = @right_of[dir]
      [{add_tuples(point, left), left, 1}, {add_tuples(point, right), right, 1}]
    else
      []
    end
    |> Enum.concat([{add_tuples(point, dir), dir, steps + 1}])
    |> Enum.filter(fn {np, _nd, steps} -> grid[np] && steps <= 10 end)
  end

  def add_tuples({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

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
      |> Enum.map(fn {val, j} -> {{i, j}, String.to_integer(val)} end)
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 94 - input-small.txt answer
# 773 - input-large.txt answer
