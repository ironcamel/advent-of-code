defmodule Main do
  def main() do
    graph = "input-large.txt" |> parse_input
    {start, _} = graph |> Enum.find(fn {key, _val} -> graph[key].type == "S" end)
    visited = dfs(graph, start)
    process(graph, visited, 0)
  end

  def process(graph, visited, sum) do
    unvisited_item =
      Enum.find(graph, fn {key, _val} ->
        not MapSet.member?(visited, key) and is_orig(key)
      end)

    if unvisited_item do
      visited2 = dfs2(elem(unvisited_item, 0), graph, visited)
      newly_visited = MapSet.difference(visited2, visited)

      if Enum.any?(newly_visited, fn {i, j} -> i == 0 || j == 0 end) do
        process(graph, visited2, sum)
      else
        cnt = newly_visited |> Enum.count(fn key -> is_orig(key) end)
        process(graph, visited2, sum + cnt)
      end
    else
      sum
    end
  end

  def is_orig({i, j}), do: rem(i, 3) == 1 and rem(j, 3) == 1

  def dfs2({i, j} = start, graph, visited) do
    visited = MapSet.put(visited, start)

    children =
      [
        {i + 1, j},
        {i - 1, j},
        {i, j + 1},
        {i, j - 1}
      ]
      |> Enum.filter(fn key -> graph[key] && !MapSet.member?(visited, key) end)

    dfs2(graph, children, visited)
  end

  def dfs2(_graph, [], visited), do: visited

  def dfs2(graph, [key | keys], visited) do
    {i, j} = key
    visited = MapSet.put(visited, key)

    children =
      [
        {i + 1, j},
        {i - 1, j},
        {i, j + 1},
        {i, j - 1}
      ]
      |> Enum.filter(fn key -> graph[key] && !MapSet.member?(visited, key) end)

    dfs2(graph, children ++ keys, visited)
  end

  def dfs(graph, key) do
    children = next_pipes(graph, key)
    dfs(graph, children, MapSet.new([key]))
  end

  def dfs(_graph, [], visited), do: MapSet.new(visited)

  def dfs(graph, [key | keys], visited) do
    visited = MapSet.put(visited, key)

    children =
      next_pipes(graph, key) |> Enum.filter(fn key -> not MapSet.member?(visited, key) end)

    dfs(graph, children ++ keys, visited)
  end

  # def n(graph, {i, j} = key), do: n(graph, key, {i - 1, j}, graph[key].type)
  # def s(graph, {i, j} = key), do: s(graph, key, {i + 1, j}, graph[key].type)
  # def e(graph, {i, j} = key), do: e(graph, key, {i, j + 1}, graph[key].type)
  # def w(graph, {i, j} = key), do: w(graph, key, {i, j - 1}, graph[key].type)

  def n(graph, {i, j} = key) do
    next_key = {i - 1, j}
    type = graph[key].type

    if type in ["S", "|", "J", "L"] && graph[next_key] &&
         graph[next_key].type in ["|", "7", "F", "S"],
       do: next_key,
       else: nil
  end

  def s(graph, {i, j} = key) do
    next_key = {i + 1, j}
    type = graph[key].type

    if type in ["S", "|", "F", "7"] && graph[next_key] &&
         graph[next_key].type in ["|", "J", "L", "S"],
       do: next_key,
       else: nil
  end

  def e(graph, {i, j} = key) do
    next_key = {i, j + 1}
    type = graph[key].type

    if type in ["S", "L", "F", "-"] && graph[next_key] &&
         graph[next_key].type in ["7", "J", "-", "S"],
       do: next_key,
       else: nil
  end

  def w(graph, {i, j} = key) do
    next_key = {i, j - 1}
    type = graph[key].type

    if type in ["S", "J", "7", "-"] && graph[next_key] &&
         graph[next_key].type in ["F", "L", "-", "S"],
       do: next_key,
       else: nil
  end

  def next_pipes(graph, key) do
    [n(graph, key), s(graph, key), e(graph, key), w(graph, key)] |> Enum.filter(& &1)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.flat_map(fn c ->
        case c do
          "|" -> [".", "|", "."]
          "-" -> ["-", "-", "-"]
          "L" -> [".", "L", "-"]
          "J" -> ["-", "J", "."]
          "7" -> ["-", "7", "."]
          "F" -> [".", "F", "-"]
          "." -> [".", ".", "."]
          "S" -> ["-", "S", "-"]
        end
      end)
    end)
    |> Enum.map(fn row ->
      Enum.map(row, fn c ->
        case c do
          "|" -> ["|", "|", "|"]
          "-" -> [".", "-", "."]
          "L" -> ["|", "L", "."]
          "J" -> ["|", "J", "."]
          "7" -> [".", "7", "|"]
          "F" -> [".", "F", "|"]
          "." -> [".", ".", "."]
          "S" -> ["|", "S", "|"]
        end
      end)
    end)
    |> Enum.reduce([], fn row, acc -> acc ++ Enum.zip(row) end)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line |> Enum.with_index() |> Enum.map(fn {val, j} -> {i, j, val} end)
    end)
    |> Enum.reduce(%{}, fn {i, j, val}, acc ->
      Map.put(acc, {i, j}, %{type: val, i: i, j: j})
    end)
  end
end

Main.main() |> IO.puts()

# 1 - input-small.txt answer
# 4 - input-small2.txt answer
# 8 - input-small3.txt answer
# 10 - input-small4.txt answer
# 355 - input-large.txt answer
