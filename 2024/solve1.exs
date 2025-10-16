defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @unit_circle [@north, @south, @east, @west]

  def main() do
    # "input-large.txt"
    "input-small.txt"
    |> parse_input()
  end

  def dfs(graph, nodes, visited \\ MapSet.new())
  def dfs(_graph, [], visited), do: visited

  def dfs(graph, [node | nodes], visited) do
    visited = MapSet.put(visited, node)

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, node) end)
      |> Enum.filter(fn p -> !MapSet.member?(visited, p) end)

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
