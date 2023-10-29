defmodule Main do
  def go() do
    # "input-small.txt"
    graph =
      "input-large.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints(&1))
      |> Enum.with_index()
      |> Enum.map(fn {row, i} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {item, j} -> to_node(item, i, j) end)
      end)

    graph
    |> List.flatten()
    |> Enum.filter(&Map.get(&1, :is_start))
    |> bfs(graph)
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
          |> Enum.into(distances, &{key(&1), distances[key(node)] + 1})

        (tail ++ neighbors) |> bfs(graph, visited, distances)

      true ->
        bfs(tail, graph, visited, distances)
    end
  end

  def p(o) do
    IO.inspect(o)
  end

  def get_neighbors(node, graph) do
    [{node.i, node.j + 1}, {node.i, node.j - 1}, {node.i - 1, node.j}, {node.i + 1, node.j}]
    |> Enum.map(&get_at(graph, &1))
    |> Enum.filter(&neighbor(node, &1))
  end

  def neighbor(_node1, nil), do: nil

  def neighbor(node1, node2) do
    if node1.h >= node2.h - 1, do: node2, else: nil
  end

  def get_at(_graph, {_, -1}), do: nil
  def get_at(_graph, {-1, _}), do: nil
  def get_at(graph, {i, j}), do: get_at(Enum.at(graph, i), j)
  def get_at(nil, _j), do: nil
  def get_at(row, j), do: Enum.at(row, j)

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
