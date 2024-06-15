defmodule Main do
  def main() do
    graph = "input-large.txt" |> parse_input()

    graph
    |> Map.keys()
    |> Enum.filter(fn key -> key not in ["start", "end"] and lower_case?(key) end)
    |> Enum.flat_map(fn key ->
      graph
      |> add_twin(key)
      |> prune
      |> search("start")
    end)
    |> Enum.map(fn path ->
      Enum.map(path, fn n -> String.replace(n, ~r/\d/, "") end)
    end)
    |> Enum.uniq()
    |> length()
  end

  def add_twin(graph, key) do
    nodes = graph[key]
    graph = Map.delete(graph, key)
    new_key1 = key <> "1"
    new_key2 = key <> "2"
    graph = Map.put(graph, new_key1, nodes)
    graph = Map.put(graph, new_key2, nodes)

    nodes
    |> Map.keys()
    |> Enum.reduce(graph, fn key2, acc ->
      nodes2 =
        acc[key2]
        |> Map.delete(key)
        |> Map.put(new_key1, true)
        |> Map.put(new_key2, true)

      Map.put(acc, key2, nodes2)
    end)
  end

  def search(graph, node, visited_set \\ MapSet.new(["end"]), visited_list \\ [], paths \\ [])

  def search(_graph, node, _visited_set, visited_list, paths) when node == "end" do
    visited_list = [node | visited_list]
    [Enum.reverse(visited_list) | paths]
  end

  def search(graph, node, visited_set, visited_list, paths) do
    visited_list = [node | visited_list]
    visited_set = MapSet.put(visited_set, node)

    graph[node]
    |> Map.keys()
    |> Enum.filter(fn n ->
      not MapSet.member?(visited_set, n) or upper_case?(n) or n == "end"
    end)
    |> Enum.flat_map(fn n ->
      search(graph, n, visited_set, visited_list, paths)
    end)
  end

  def lower_case?(s), do: String.downcase(s) == s
  def upper_case?(s), do: not lower_case?(s)

  def prune(graph) do
    pruned =
      Map.reject(graph, fn {_key, nodes} ->
        map_size(nodes) == 1 and Map.keys(nodes) |> hd |> lower_case?()
      end)

    pruned =
      pruned
      |> Enum.map(fn {key, nodes} ->
        nodes = Map.filter(nodes, fn {key, _val} -> pruned[key] end)
        {key, nodes}
      end)
      |> Map.new()

    if map_size(graph) == map_size(pruned) do
      pruned
    else
      prune(pruned)
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [node1, node2] = String.split(line, "-")

      acc
      |> put_in([Access.key(node1, %{}), node2], true)
      |> put_in([Access.key(node2, %{}), node1], true)
    end)
  end
end

Main.main() |> IO.puts()

# 36 - input-small1.txt answer
# 103 - input-small2.txt answer
# 3509 - input-small3.txt answer
# 99138 - input-large.txt answer
