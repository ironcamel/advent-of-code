defmodule Main do
  @nsew [{-1, 0}, {1, 0}, {0, 1}, {0, -1}]

  def main() do
    grid = "input-large.txt" |> parse_input()

    basins =
      grid
      |> Enum.filter(fn {pos, h} ->
        Enum.all?(@nsew, fn delta ->
          val = grid[add_delta(pos, delta)]
          val == nil or val > h
        end)
      end)

    basins
    |> Enum.map(fn {node, _} -> dfs(grid, [node]) |> MapSet.size() end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def dfs(grid, nodes, visited \\ MapSet.new())
  def dfs(_grid, [], visited), do: visited

  def dfs(grid, [node | nodes], visited) do
    visited = MapSet.put(visited, node)

    next_nodes =
      @nsew
      |> Enum.map(fn delta -> add_delta(node, delta) end)
      |> Enum.filter(fn n -> grid[n] end)
      |> Enum.filter(fn n -> not MapSet.member?(visited, n) and grid[n] != 9 end)

    dfs(grid, next_nodes ++ nodes, visited)
  end

  def add_delta({i, j}, {di, dj}), do: {i + di, j + dj}

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

# 1134 - input-small.txt answer
# 847504 - input-large.txt answer
