defmodule Main do
  def main() do
    #graph = "input-small.txt" |> parse_input()
    graph = "input-large.txt" |> parse_input()

    graph
    |> karger
    |> Map.keys
    |> Enum.map(&length/1)
    |> Enum.product

  end

  #def karger(graph), do: karger(graph, graph |> Map.values |> hd |> Map.values |> hd)
  #def karger(graph, cut_size) when cut_size == 3, do: graph

  # https://en.wikipedia.org/wiki/Karger%27s_algorithm
  def karger(graph) do
    new_graph = contract(graph)
    cut_size = new_graph |> Map.values |> hd |> Map.values |> hd
    p [cut_size: cut_size]
    if cut_size == 3 do
      new_graph
    else
      karger(graph)
    end
  end

  def contract(graph) do
    contract(graph, Map.keys(graph))
  end

  def contract(graph, nodes) when length(nodes) == 2, do: graph

  def contract(graph, _nodes) do
    [{node1, node2}] =
      graph
      |> Enum.flat_map(fn {n1, edges} ->
        #p [n1: n1]
        #p [edges: edges]
        Enum.flat_map(edges, fn {n2, cnt} -> List.duplicate([{n1, n2}], cnt) end)
      end)
      |> Enum.random
      #|> dbg

    #p [random_edge: {node1, node2}]

    edges1 = graph[node1] |> Map.delete(node2)
    edges2 = graph[node2] |> Map.delete(node1)
    super_node = node1 ++ node2
    super_edges =
      edges1
      |> Enum.reduce(edges2, fn {k, val1}, acc ->
        val2 = edges2[k]
        if val2 do
          Map.put(acc, k, val1 + val2)
        else
          Map.put(acc, k, val1)
        end
      end)

    #p [super_edges: super_edges]

    super_edges
    |> Enum.reduce(graph, fn {n2, v2}, acc ->
      e2 = acc[n2] |> Map.delete(node1) |> Map.delete(node2) |> Map.put(super_node, v2)
      Map.put(acc, n2, e2)
    end)
    |> Map.delete(node1)
    |> Map.delete(node2)
    |> Map.put(super_node, super_edges)
    |> contract()
  end

  def parse_input(path) do
    graph =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> String.split(line, [": ", " "]) end)
      |> Enum.reduce(%{}, fn [node1 | rest], acc ->
        edges = rest |> Enum.map(fn node2 -> {[node2], 1} end) |> Map.new
        Map.put(acc, [node1], edges)
      end)

    Enum.reduce(graph, graph, fn {node1, edges}, acc ->
      Enum.reduce(edges, acc, fn {node2, _}, acc ->
        edges2 = acc |> Map.get(node2, %{}) |> Map.put(node1, 1)
        Map.put(acc, node2, edges2)
      end)
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> IO.puts()

# 54 - input-small.txt answer
# 600225 - input-large.txt answer
# elixir solve1.exs  218.47s user 12.40s system 109% cpu 3:30.29 total
