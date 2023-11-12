defmodule Main do
  def go() do
    # input = "input-small.txt"
    input = "input-large.txt"
    valley = parse_input(input)
    start = {1,2}
    finish = goal(valley)

    [{start, finish}, {finish, start}, {start, finish}]
    |> Enum.reduce(0, fn {start, finish}, acc ->
      time(valley, start, finish, acc)
    end)
  end

  def time(valley, start, finish, t) do
    try do
      bfs(valley, start, finish, t)
    catch
      t -> t
    end
  end

  defp bfs(graph, n, finish, t) do
    bfs(graph, [n], [], t, finish)
  end

  defp bfs(graph, [], neighbors, t, finish) do
    bfs(graph, Enum.uniq(neighbors), [], t + 1, finish)
  end

  defp bfs(graph, [n | tail], neighbors, t, finish) do
    if n == finish do
      throw(t - 1)
    end

    {i0, j0} = n

    new_neighbors =
      [{1, 0}, {0, 1}, {0, 0}, {-1, 0}, {0, -1}]
      |> Enum.map(fn {i1, j1} -> {i0 + i1, j0 + j1} end)
      |> Enum.filter(fn {i, j} -> graph[i][j] && graph[i][j] != "#" end)
      |> Enum.filter(fn {i, j} -> not is_blizzard(graph, i, j, t) end)

    bfs(graph, tail, new_neighbors ++ neighbors, t, finish)
  end

  def w(valley), do: map_size(valley[1])
  def h(valley), do: map_size(valley)
  def goal(valley), do: {h(valley), w(valley) - 1}

  def is_blizzard(valley, i, j, t) do
    ["<", ">", "v", "^"]
    |> Enum.any?(fn c -> is_blizzard(valley, i, j, t, c) end)
  end

  def is_blizzard(valley, i, j, t, ">" = c) do
    j0 = Integer.mod(j - 2 - t, w(valley) - 2) + 2
    valley[i][j0] == c
  end

  def is_blizzard(valley, i, j, t, "<" = c) do
    j0 = Integer.mod(j - 2 + t, w(valley) - 2) + 2
    valley[i][j0] == c
  end

  def is_blizzard(valley, i, j, t, "v" = c) do
    i0 = Integer.mod(i - 2 - t, h(valley) - 2) + 2
    valley[i0][j] == c
  end

  def is_blizzard(valley, i, j, t, "^" = c) do
    i0 = Integer.mod(i - 2 + t, h(valley) - 2) + 2
    valley[i0][j] == c
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.reduce(%{}, fn {line, i}, acc ->
      acc = Map.put(acc, i, %{})

      line
      |> String.codepoints()
      |> Enum.with_index(1)
      |> Enum.map(fn {c, j} -> {i, j, c} end)
      |> put_tiles(acc)
    end)
  end

  def put_tiles(tiles, map) do
    Enum.reduce(tiles, map, fn {i, j, c}, acc -> put_in(acc, [i, j], c) end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.p(Main.go())

# 54 - input-small.txt answer
# 807 - input-large.txt answer
