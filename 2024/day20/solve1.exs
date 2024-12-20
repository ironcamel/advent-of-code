defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}
  @unit_circle [@north, @south, @east, @west]

  def main() do
    #graph = parse_input("input-small.txt")
    graph = parse_input("input-large.txt")
    #graph = parse_input("foo.txt")
    start = graph |> Enum.find(fn {_p, v} -> v == "S" end) |> elem(0)
    target = graph |> Enum.find(fn {_p, v} -> v == "E" end) |> elem(0)
    dbg start
    dbg target

    raw_time = bfs(graph, [{start, 0}], target)

    graph =
      graph
      |> Enum.map(fn {pos, val} -> if val in ["S", "E"], do: {pos, "."}, else: {pos, val} end)
      |> Map.new()

    graph
    |> Enum.filter(fn {_pos, val} -> val == "#" end)
    |> Enum.filter(fn {pos, _val} ->
      {graph[add_points(pos, @north)], graph[add_points(pos, @south)]} == {".", "."} or
        {graph[add_points(pos, @east)], graph[add_points(pos, @west)]} == {".", "."}
    end)
    |> Enum.map(fn {wall, _} ->
      graph
      |> Map.put(wall, ".")
      |> bfs([{start, 0}], target)
      |> then(fn t -> raw_time - t end)
    end)
    #|> Enum.frequencies()
    |> Enum.count(fn n -> n >= 100 end)
  end

  def bfs(graph, nodes, target, visited \\ %{})
  def bfs(_graph, [{pos, depth} | _nodes], target, _visited) when pos == target, do: depth

  def bfs(graph, [{pos, _depth} | nodes], target, visited) when is_map_key(visited, pos) do
    bfs(graph, nodes, target, visited)
  end

  def bfs(graph, [{pos, depth} | nodes], target, visited) do
    visited = Map.put(visited, pos, true)

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, pos) end)
      |> Enum.reject(fn p -> visited[p] || graph[p] == "#" end)
      |> Enum.map(fn pos -> {pos, depth + 1} end)

    bfs(graph, nodes ++ next_nodes, target, visited)
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

# 1363 - input-large.txt answer
