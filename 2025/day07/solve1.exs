defmodule Main do
  # @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  # @unit_circle [@north, @south, @east, @west]

  def main() do
    #grid = "input-small.txt" |> parse_input()
    grid = parse_input("input-large.txt")
    {start, _} = Enum.find(grid, fn {_k, v} -> v == "S" end)
    dfs(grid, [start])
  end

  def dfs(graph, nodes, visited \\ MapSet.new())
  def dfs(_graph, [], visited), do: MapSet.size(visited)

  def dfs(graph, [node | nodes], visited) do
    val = graph[node]
    #dbg([node, val, count])

    next_nodes =
      cond do
        val == "S" or val == "." ->
          [add_points(node, @south)]

        val == nil ->
          []

        val == "^" ->
          Enum.map([@west, @east], fn dir -> node |> add_points(dir) |> add_points(@south) end)
      end

    next_nodes = Enum.filter(next_nodes, fn p -> !MapSet.member?(visited, p) end)
    visited = if val == "^", do: MapSet.put(visited, node), else: visited
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

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 1626 - input-large.txt answer
