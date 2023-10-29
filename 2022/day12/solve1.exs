defmodule Main do
  def go() do
    # "input-small.txt"
    graph =
      "input-large.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints(&1))
      |> to_matrix(&to_node/3)

    nodes =
      graph
      |> Map.values()
      |> Enum.map(&Map.values(&1))
      |> List.flatten()
      |> Enum.filter(&Map.get(&1, :is_start))

    bfs(nodes, graph)
  end

  def key(node), do: "#{node.i},#{node.j}"

  def bfs(nodes, graph) do
    distances = %{key(hd(nodes)) => 0}
    bfs(nodes, graph, %{}, distances)
  end

  def bfs(nodes, graph, visited, distances) do
    [node | tail] = nodes

    cond do
      node[:is_end] ->
        distances[key(node)]

      !Map.get(visited, key(node)) ->
        visited = Map.put(visited, key(node), true)
        neighbors = get_neighbors(node, graph)
        distances =
          neighbors
          |> Enum.into(distances, &({key(&1), distances[key(node)] + 1}))
        (tail ++ neighbors) |> bfs(graph, visited, distances)

      true ->
        bfs(tail, graph, visited, distances)
    end
  end

  def p(o) do
    IO.inspect(o)
  end

  def get_neighbors(node, graph) do
    [:r, :l, :u, :d]
    |> Enum.map(&neighbor(node, graph, &1))
    |> Enum.filter(& &1)
  end

  def neighbor(node, graph, :r), do: neighbor(node, graph[node.i][node.j + 1])
  def neighbor(node, graph, :l), do: neighbor(node, graph[node.i][node.j - 1])
  def neighbor(node, graph, :u), do: neighbor(node, graph[node.i - 1][node.j])
  def neighbor(node, graph, :d), do: neighbor(node, graph[node.i + 1][node.j])
  def neighbor(_node1, nil), do: nil

  def neighbor(node1, node2) do
    if node1.h >= node2.h - 1, do: node2, else: nil
  end

  def to_matrix(list, fun) do
    list
    |> Enum.with_index()
    |> Enum.into(%{}, fn {row, i} -> {i, row} end)
    |> Enum.reduce(%{}, fn {i, row}, map ->
      val =
        row
        |> Enum.with_index()
        |> Enum.into(%{}, fn {item, j} -> {j, fun.(item, i, j)} end)

      Map.put(map, i, val)
    end)
  end

  def to_node("S", i, j) do
    to_node("a", i, j)
    |> Map.merge(%{is_start: true, distance: 0, mark: "S"})
  end

  def to_node("E", i, j) do
    to_node("z", i, j)
    |> Map.merge(%{is_end: true, mark: "E"})
  end

  def to_node(c, i, j) do
    %{mark: c, h: c |> to_charlist() |> hd(), i: i, j: j}
  end
end

IO.inspect(Main.go())

# 31 - input-small.txt answer
# 383 - input-large.txt answer
