defmodule Main do

  def main() do
    graph = "input-large.txt" |> parse_input
    #graph = "input-small.txt" |> parse_input # 1
    #graph = "input-small2.txt" |> parse_input # 4
    #graph = "input-small3.txt" |> parse_input # 8
    #graph = "input-small4.txt" |> parse_input # 10
    {start, _} = graph |> Enum.find(fn {key, val} -> graph[key].type == "S" end)
    visited = dfs(graph, start) |> MapSet.new()
    process(graph, visited, 0)
  end

  def process(graph, visited, sum) do
    start = graph |> Enum.sort() |> Enum.find(fn {key, val} -> (not MapSet.member?(visited, key)) and is_dot(graph, key) end)
    if start do
      p [start: start]
      visited2 = dfs2(elem(start, 0), graph, visited)
      visited3 = MapSet.difference(visited2, visited)
      if Enum.any?(visited3, fn {i, j} -> i == 0 || j == 0 end) do
        p "this is outside the loop"
        process(graph, visited2, sum)
      else
        cnt = visited3 |> Enum.count(fn key -> is_dot(graph, key) end)
        #p [adding_cnt: cnt, visited3: visited3]
        p [adding_cnt: cnt]
        process(graph, visited2, sum + cnt)
      end
    else
      sum
    end
  end

  def is_dot(graph, {i, j} = key) do
    #rem(i, 3) == 1 and rem(j, 3) == 1 and graph[key] != nil and graph[key].type == "." 
    rem(i, 3) == 1 and rem(j, 3) == 1
  end

  def is_dotzzz(graph, {i, j}) do
      [

        #{i - 2, j - 2},
        #{i - 2, j - 1},
        #{i - 2, j},
        #{i - 2, j + 1},
        #{i - 2, j + 2},

        #{i - 1, j - 2},
        {i - 1, j - 1},
        {i - 1, j},
        {i - 1, j + 1},
        #{i - 1, j + 2},

        #{i, j - 2},
        {i, j - 1},
        {i, j},
        {i, j + 1},
        #{i, j + 2},

        #{i + 1, j - 2},
        {i + 1, j - 1},
        {i + 1, j},
        {i + 1, j + 1},
        #{i + 1, j + 2},

        #{i + 2, j - 2},
        #{i + 2, j - 1},
        #{i + 2, j},
        #{i + 2, j + 1},
        #{i + 2, j + 2},
      ]
      |> Enum.all?(fn key -> graph[key] && graph[key].type == "." end)
  end

  def dfs2({i, j} = start, graph, visited) do
    visited = MapSet.put(visited, start)
    children = 
      [
        {i + 1, j},
        {i - 1, j},
        #{i, j},
        {i, j + 1},
        {i, j - 1},
      ]
      |> Enum.filter(fn key -> graph[key] end)
      |> Enum.filter(fn key -> not MapSet.member?(visited, key) end)

    dfs2(graph, children, visited)
  end

  def dfs2(_graph, [], visited), do: visited

  def dfs2(graph, [node | nodes], visited) do
    {i, j} = node
    visited = MapSet.put(visited, node)
    children = 
      [
        {i + 1, j},
        {i - 1, j},
        {i, j + 1},
        {i, j - 1},
      ]
      #|> Enum.filter(fn key -> graph[key] && graph[key].type == "." end)
      |> Enum.filter(fn key -> graph[key] end)
      |> Enum.filter(fn node -> not MapSet.member?(visited, node) end)
    dfs2(graph, children ++ nodes, visited)
  end

  def dfs(graph, node) do
    children = next_pipes(graph, node)
    dfs(graph, children, MapSet.new([node]))
  end

  def dfs(_graph, [], visited), do: visited

  def dfs(graph, [node | nodes], visited) do
    visited = MapSet.put(visited, node)
    children = next_pipes(graph, node) |> Enum.filter(fn node -> not MapSet.member?(visited, node) end)
    dfs(graph, children ++ nodes, visited)
  end

  # .F-7.
  # .|.|.
  # .L-J.

  def n(graph, {i, j} = key), do: n(graph, key, {i - 1, j}, graph[key].type)
  def s(graph, {i, j} = key), do: s(graph, key, {i + 1, j}, graph[key].type)
  def e(graph, {i, j} = key), do: e(graph, key, {i, j + 1}, graph[key].type)
  def w(graph, {i, j} = key), do: w(graph, key, {i, j - 1}, graph[key].type)

  def n(graph, key, val, type) do
    if type in ["S", "|", "J", "L"] && graph[val] && graph[val].type in ["|", "7", "F", "S"], do: val, else: nil
  end

  def s(graph, key, val, type) do
    if type in ["S", "|", "F", "7"] && graph[val] && graph[val].type in ["|", "J", "L", "S"], do: val, else: nil
  end

  def e(graph, key, val, type) do
    if type in ["S", "L", "F", "-"] && graph[val] && graph[val].type in ["7", "J", "-", "S"], do: val, else: nil
  end

  def w(graph, key, val, type) do
    if type in ["S", "J", "7", "-"] && graph[val] && graph[val].type in ["F", "L", "-", "S"], do: val, else: nil
  end

  def next_pipes(graph, {i, j} = key) do
    [n(graph, key), s(graph, key), e(graph, key), w(graph, key)]
    |> Enum.filter(& &1)
  end

  def parse_input(path) do
    rows =
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
      |> Enum.with_index()

    Enum.map(rows, fn {row, i} ->
      #cols = Enum.with_index(row)
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
    |> p
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line |> Enum.with_index() |> Enum.map(fn {val, j} -> {i, j, val} end)
    end)
    #|> p
    |> pp
    |> Enum.reduce(%{}, fn {i, j, val}, acc ->
      is_og = rem(i, 3) == 1 and rem(j, 3) == 1
      Map.put(acc, {i, j}, %{type: val, i: i, j: j})
    end)
  end

  def pp(rows) do
    rows |> Enum.filter(fn {i, j, c} -> rem(i, 3) == 1 and rem(j, 3) == 1 end) |> p
    rows
  end

  def p(o, opts \\ []) do
    o
    #IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> IO.inspect()

# {2687, 871}
# 871 - too high
# 567 - too high
# 40 - wrong
# 38 - wrong
# Sun Dec 10 04:30:09 EST 2023
# 37 - wrong
# Sun Dec 10 04:36:36 EST 2023
# 47 - wrong
# Sun Dec 10 05:13:36 EST 2023
# please wait 10 minutes before trying again
