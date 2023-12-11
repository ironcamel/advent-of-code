# The trick I used to solve day 10 part 2 was to “stretch” the input data to
# guarantee that there will be space everywhere inside of the loop. Consider a
# loop which has no space inside such as:
#
# ╔╗
# ║║
# ╚╝
#
# You would convert that to:
#
# ......
# .╔══╗.
# .║..║.
# .║..║.
# .║..║.
# .║..║.
# .║..║.
# .╚══╝.
# ......
#
# You can do this by expanding every 1x1 unit into a 3x3 unit. For example,
# given a vertical pipe, convert it like so:
#
#      .║.
# ║ => .║.
#      .║.
#
# A dot becomes a 3x3 grid of dots:
#
#      ...
# . => ...
#      ...
#
# Corners get converted like so:
#
#      ...
# ╔ => .╔.
#      .║.
#
# Once you have converted the data, do one DFS with the provided starting point
# to find the loop. Now pick any point that is not part of the loop.
#
# There are only 2 possibilities. You either picked a point outside of the loop
# (such as A) or a point inside of the loop (such as B):
#
# ......
# .╔══╗.
# A║..║.
# .║..║.
# .║.B║.
# .║..║.
# .║..║.
# .╚══╝.
# ......
#
# Now do a DFS using the point that you picked. If your DFS search caused you
# to traverse the edge of your graph, then you know you were outside of the
# loop.  In that case, you just do one more DFS starting with any point that
# you haven’t visited yet. This DFS search will be guaranteed to traverse the
# entirety of the inside of the loop. Then you just count the number of nodes
# your last DFS visited (taking into account the “stretching”) to solve the
# puzzle.
#
defmodule Main do
  def main() do
    graph = "input-large.txt" |> parse_input
    {start, _} = graph |> Enum.find(fn {key, _val} -> graph[key].type == "S" end)
    visited = dfs(graph, start)
    search_unvisited(graph, visited, 0)
  end

  def search_unvisited(graph, visited, sum) do
    unvisited_item =
      Enum.find(graph, fn {key, _val} ->
        not MapSet.member?(visited, key) and is_orig(key)
      end)

    if unvisited_item do
      {start_key, _} = unvisited_item
      visited2 = dfs2(graph, start_key, visited)
      newly_visited = MapSet.difference(visited2, visited)

      # If any of the keys are on an edge (i=0 or j=0), then ignore because we must be outside of the loop
      if Enum.any?(newly_visited, fn {i, j} -> i == 0 || j == 0 end) do
        search_unvisited(graph, visited2, sum)
      else
        cnt = newly_visited |> Enum.count(fn key -> is_orig(key) end)
        search_unvisited(graph, visited2, sum + cnt)
      end
    else
      sum
    end
  end

  # We stretched the original graph by a factor of 9. Every 1x1 unit became 3x3.
  def is_orig({i, j}), do: rem(i, 3) == 1 and rem(j, 3) == 1

  def dfs2(graph, key, visited) when not is_list(key), do: dfs2(graph, [key], visited)

  def dfs2(_graph, [], visited), do: visited

  def dfs2(graph, [key | keys], visited) do
    visited = MapSet.put(visited, key)
    {i, j} = key

    children =
      [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
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
