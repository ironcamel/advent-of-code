defmodule Main do
  @unit_circle [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def main() do
    "input-large.txt"
    |> parse_input()
    |> dfs()
    |> then(&(&1 - 1))
  end

  def dfs(grid) do
    dfs(grid, [{0,1}], MapSet.new(), [])
  end

  def dfs(_grid, [], _seen, path) do
    path |> length
  end

  def dfs(grid, [node | nodes], seen, path), do: dfs(grid, [node | nodes], seen, path, MapSet.member?(seen, node))
  def dfs(grid, [_node | nodes], seen, path, true), do: dfs(grid, nodes, seen, path)
  def dfs(grid, [node | nodes], seen, path, false) do
    seen = MapSet.put(seen, node)
    path = [node | path]
    neighbors = get_neig(grid, node, seen)

    if length(neighbors) <= 1 do
      dfs(grid, neighbors ++ nodes, seen, path)
    else
      neighbors
      |> Enum.map(fn n ->
        dfs(grid, [n | nodes], seen, path)
      end)
      |> Enum.max
    end
  end

  def get_neig(grid, node, seen), do: get_neig(grid, node, seen, grid[node])
  def get_neig(_grid, node, _seen, ">"), do: [add_points(node, {0, 1})]
  def get_neig(_grid, node, _seen, "v"), do: [add_points(node, {1, 0})]
  def get_neig(_grid, node, _seen, "<"), do: [add_points(node, {0, -1})]
  def get_neig(_grid, node, _seen, "^"), do: [add_points(node, {-1, 0})]
  def get_neig(grid, node, seen, _val) do
    @unit_circle
    |> Enum.map(fn delta -> add_points(node, delta) end)
    |> Enum.filter(fn n -> grid[n] && grid[n] != "#" && !MapSet.member?(seen, n) end)
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

Main.main() |> IO.puts()

# 94 - input-small.txt answer
# 2386 - input-large.txt answer
