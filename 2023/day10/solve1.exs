defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")
    {start, _} = graph |> Enum.find(fn {key, _val} -> graph[key].type == "S" end)
    cnt = dfs(graph, [start]) |> MapSet.size()
    ceil(cnt / 2)
  end

  def dfs(graph, nodes, visited \\ MapSet.new())
  def dfs(_graph, [], visited), do: visited

  def dfs(graph, [node | nodes], visited) do
    visited = MapSet.put(visited, node)
    children = next_pipes(graph, node) |> Enum.reject(&MapSet.member?(visited, &1))
    dfs(graph, children ++ nodes, visited)
  end

  def check_types(graph, key, next_key, src_types, target_types) do
    src_type = graph[key].type

    if src_type in src_types && graph[next_key] && graph[next_key].type in target_types,
      do: next_key,
      else: nil
  end

  def n(graph, {i, j} = key) do
    next_key = {i - 1, j}
    check_types(graph, key, next_key, ["S", "|", "J", "L"], ["|", "7", "F", "S"])
  end

  def s(graph, {i, j} = key) do
    next_key = {i + 1, j}
    check_types(graph, key, next_key, ["S", "|", "F", "7"], ["|", "J", "L", "S"])
  end

  def e(graph, {i, j} = key) do
    next_key = {i, j + 1}
    check_types(graph, key, next_key, ["S", "L", "F", "-"], ["7", "J", "-", "S"])
  end

  def w(graph, {i, j} = key) do
    next_key = {i, j - 1}
    check_types(graph, key, next_key, ["S", "J", "7", "-"], ["F", "L", "-", "S"])
  end

  def next_pipes(graph, key) do
    [n(graph, key), s(graph, key), e(graph, key), w(graph, key)] |> Enum.filter(& &1)
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
      |> Enum.map(fn {val, j} -> {i, j, val} end)
    end)
    |> Enum.reduce(%{}, fn {i, j, val}, acc ->
      Map.put(acc, {i, j}, %{type: val})
    end)
  end
end

Main.main() |> IO.puts()

# 4 - input-small.txt answer
# 7097 - input-large.txt answer
