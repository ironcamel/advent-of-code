defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")
    {start, _} = graph |> Enum.find(fn {key, val} -> graph[key].type == "S" end)
    cnt = dfs(graph, start)
    ceil(cnt / 2)
  end

  def dfs(graph, node) do
    children = next_pipes(graph, node) |> Enum.take(1)
    dfs(graph, children, MapSet.new([node]), 0)
  end

  def dfs(_graph, [], _visited, cnt), do: cnt

  def dfs(graph, [node | nodes], visited, cnt) do
    visited = MapSet.put(visited, node)

    children =
      next_pipes(graph, node) |> Enum.filter(fn node -> not MapSet.member?(visited, node) end)

    dfs(graph, children ++ nodes, visited, cnt + 1)
  end

  def n(graph, {i, j} = key), do: n(graph, key, {i - 1, j}, graph[key].type)
  def s(graph, {i, j} = key), do: s(graph, key, {i + 1, j}, graph[key].type)
  def e(graph, {i, j} = key), do: e(graph, key, {i, j + 1}, graph[key].type)
  def w(graph, {i, j} = key), do: w(graph, key, {i, j - 1}, graph[key].type)

  def n(graph, key, val, type) do
    if type in ["S", "|", "J", "L"] and graph[val].type in ["|", "7", "F", "S"],
      do: val,
      else: nil
  end

  def s(graph, key, val, type) do
    if type in ["S", "|", "F", "7"] and graph[val].type in ["|", "J", "L", "S"],
      do: val,
      else: nil
  end

  def e(graph, key, val, type) do
    if type in ["S", "L", "F", "-"] and graph[val].type in ["7", "J", "-", "S"],
      do: val,
      else: nil
  end

  def w(graph, key, val, type) do
    if type in ["S", "J", "7", "-"] and graph[val].type in ["F", "L", "-", "S"],
      do: val,
      else: nil
  end

  def next_pipes(graph, {i, j} = key) do
    [n(graph, key), s(graph, key), e(graph, key), w(graph, key)]
    |> Enum.filter(& &1)
  end

  def parse_input(path) do
    graph =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.map(fn {val, j} -> {i, j, val} end)
      end)
      |> Enum.reduce(%{}, fn {i, j, val}, acc ->
        Map.put(acc, {i, j}, %{type: val})
      end)
  end
end

Main.main() |> IO.puts()

# 7097 - input-large.txt answer
