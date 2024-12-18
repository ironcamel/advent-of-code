Mix.install([:heap])

defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
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
    {dist, prev} = dijkstra(grid, start, target)

    {_score, dir} =
      @unit_circle
      |> Enum.map(fn dir -> {dist[{target, dir}], dir} end)
      |> Enum.min()

    dfs(prev, [{target, dir}])
    |> Enum.map(fn {pos, _dir} -> pos end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def dfs(prev, nodes, visited \\ MapSet.new())
  def dfs(_prev, [], visited), do: visited

  def dfs(prev, [node | nodes], visited) do
    visited = MapSet.put(visited, node)
    next_nodes = MapSet.to_list(prev[node] || MapSet.new())
    dfs(prev, next_nodes ++ nodes, visited)
  end

  def dijkstra(grid, start, target) do
    start_node = {start, @east}
    dist = %{start_node => 0}
    prev = %{}
    visited = MapSet.new()
    nodes = Heap.new() |> Heap.push({0, start_node})
    dijkstra(grid, nodes, visited, dist, prev, target)
  end

  def dijkstra(grid, nodes, visited, dist, prev, target) do
    {_score, {pos, dir} = node} = Heap.root(nodes)

    if pos == target do
      {dist, prev}
    else
      nodes = Heap.pop(nodes)
      visited = MapSet.put(visited, node)
      straight_pos = add_points(pos, dir)

      neighbors =
        [
          {{straight_pos, dir}, 1},
          {{pos, @left_of[dir]}, 1000},
          {{pos, @right_of[dir]}, 1000}
        ]
        |> Enum.reject(fn {{pos, _dir} = node, _cost} ->
          MapSet.member?(visited, node) or grid[pos] == "#"
        end)

      {dist, prev} = update_dist(node, dist, prev, neighbors)

      nodes =
        neighbors
        |> Enum.map(fn {node, _cost} -> node end)
        |> Enum.reduce(nodes, fn node, acc ->
          Heap.push(acc, {dist[node], node})
        end)

      dijkstra(grid, nodes, visited, dist, prev, target)
    end
  end

  def update_dist(node1, dist, prev, neighbors) do
    Enum.reduce(neighbors, {dist, prev}, fn {node2, cost}, {dist, prev} ->
      val = dist[node1] + cost

      cond do
        !dist[node2] or val < dist[node2] ->
          dist = Map.put(dist, node2, val)
          prev = Map.put(prev, node2, MapSet.new([node1]))
          {dist, prev}

        val == dist[node2] ->
          dist = Map.put(dist, node2, val)
          prev_nodes = prev |> Map.get(node2, MapSet.new()) |> MapSet.put(node1)
          prev = Map.put(prev, node2, prev_nodes)
          {dist, prev}

        true ->
          {dist, prev}
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

  def print(grid, path) do
    path = MapSet.new(path)

    for i <- 0..140 do
      0..140
      |> Enum.map(fn j ->
        if MapSet.member?(path, {i, j}) do
          "O"
        else
          grid[{i, j}] || " "
        end
      end)
      |> Enum.join()
      |> IO.puts()
    end
  end
end

Main.main() |> IO.puts()

# 45 - input-small.txt answer
# 64 - input-small2.txt answer
# 451 - input-large.txt answer
