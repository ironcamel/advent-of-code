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

  def async(items) do
    items
    |> Task.async_stream(&solve/1, max_concurrency: 200, ordered: false)
    |> Enum.map(fn {:ok, val} -> val end)
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

  def det({i1, j1}, {i2, j2}), do: i1 * j2 - i2 * j1

  def calc_area([_]), do: 1

  def calc_area(points) do
    points
    |> Enum.concat([hd(points)])
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [p1, p2] -> det(p1, p2) end)
    |> Enum.sum()
    |> then(fn n -> abs(n) / 2 + length(points) / 2 + 1 end)
    |> dbg
  end

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
