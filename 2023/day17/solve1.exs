defmodule Main do
  @north {0, 1}
  @south {0, -1}
  @east {1, 0}
  @west {-1, 0}

  def main() do
    # grid = "input-small.txt" |> parse_input()
    grid = "input-large.txt" |> parse_input()   
    target = grid |> Map.keys() |> Enum.sort() |> List.last()

    {dist, _prev} = search(grid)

    dist
    |> Enum.filter(fn {{n, _, _}, _val} -> n == target end)
    |> Enum.map(fn {_k, val} -> val end)
    |> Enum.min()
  end

  def search(grid) do
    start_node = {{0, 0}, @east, 3}
    dist = %{start_node => 0}
    prev = %{}
    visited = MapSet.new()
    search(grid, [start_node], visited, dist, prev)
  end

  def search(_grid, [], _visited, dist, prev), do: {dist, prev}

  def search(grid, nodes, visited, dist, prev) do
    {nodes, node} = pop_nearest(nodes, dist)

    if MapSet.member?(visited, node) do
      search(grid, nodes, visited, dist, prev)
    else
      visited = MapSet.put(visited, node)
      neighbors = get_neighbors(grid, node)
      {dist, prev} = update_dist(grid, node, visited, dist, prev, neighbors)
      # dbg
      search(grid, neighbors ++ nodes, visited, dist, prev)
    end
  end

  def update_dist(grid, node, visited, dist, prev) do
    update_dist(grid, node, visited, dist, prev, get_neighbors(grid, node))
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

  def pop_nearest(nodes, dist) do
    # {_val, node} = nodes |> Enum.map(fn node -> {dist[node], node, _} end) |> Enum.min()
    node = nodes |> Enum.min_by(fn node -> dist[node] end)
    nodes = List.delete(nodes, node)
    {nodes, node}
  end

  def get_neighbors(grid, {point, dir, steps}) do
    # p(getting_neighbors_for: node)
    left = left_dir(dir)
    right = right_dir(dir)

    [
      {add_tuples(point, dir), dir, steps + 1},
      {add_tuples(point, left), left, 1},
      {add_tuples(point, right), right, 1}
    ]
    |> Enum.filter(fn {np, _nd, steps} ->
      grid[np] && steps <= 3
    end)
  end

  def left_dir(dir) do
    case dir do
      @north -> @west
      @south -> @east
      @east -> @north
      @west -> @south
    end
  end

  def right_dir(dir) do
    case dir do
      @north -> @east
      @south -> @west
      @east -> @south
      @west -> @north
    end
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

  def print(grid, path) do
    {{max_i, max_j}, _} = Enum.max(grid)
    path = Enum.map(path, fn {point, _dir} -> point end)

    for i <- 0..max_i do
      for j <- 0..max_j do
        node = {i, j}

        if node in path do
          IO.write(".")
        else
          IO.write(grid[{i, j}])
        end
      end

      IO.puts("")
    end

    IO.puts("")
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
    o
  end
end

Main.main() |> IO.inspect()

# 102 - input-small.txt answer
# 674 - input-large.txt answer
