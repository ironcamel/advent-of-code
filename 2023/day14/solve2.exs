defmodule Main do

  def main() do
    graph = "input-large.txt" |> parse_input
    #graph = "input-small.txt" |> parse_input

    #num_rows = graph |> Enum.map(fn {i, j} -> i end) |> Enum.max() |> then(&(&1 + 1))
    max_i = graph |> Enum.map(fn {{i, _j}, _} -> i end) |> Enum.max()
    num_rows = max_i + 1

    #:timer.tc(fn -> Map.equal?(m1, m2) end)
    {graph, cnt1, cnt2} = find_cycle(graph, max_i)
    IO.inspect {cnt1, cnt2}
    need = rem(1_000_000_000 - cnt1, cnt2 - cnt1)

    1..(need)
    |> Enum.reduce(graph, fn _, acc ->
      tilt(acc)
      #|> print_graph(max_i)
    end)
    |> Enum.map(fn {{i, _j}, val} ->
      case val do
        "O" -> num_rows - i
        _ -> 0
      end
    end)
    |> Enum.sum()

  end

  def find_cycle(graph, max_i) do
    find_cycle(graph, max_i, 1, %{ graph => 0 })
  end

  #def find_cycle(graph, max_i, 10_001), do: :halt

  def find_cycle(graph, max_i, cnt, seen) do
    new_graph = tilt(graph)
    #p "old graph:"
    #print_graph(graph, max_i)
    #p "new graph:"
    #print_graph(new_graph, max_i)
    #if new_graph == graph do
    #if Map.equal?(new_graph, graph) do
    seen_cnt = Map.get(seen, new_graph)
    if seen_cnt do
      {new_graph, seen_cnt, cnt}
    else
      find_cycle(new_graph, max_i, cnt + 1, Map.put(seen, new_graph, cnt))
    end
  end

  def tilt(graph) do
    [:n, :w, :s, :e]
    |> Enum.reduce(graph, fn dir, acc ->
      tilt(acc, dir)
    end)
  end

  def tilt(graph, dir) do
    new_graph =
      graph
      |> sort_for(dir)
      |> Enum.reduce(graph, fn {key, val}, acc ->
        tilt(acc, key, val, dir)
      end)
    #if new_graph == graph do
    if Map.equal?(new_graph, graph) do
      graph
    else
      tilt(new_graph, dir)
    end
  end

  def sort_for(graph, :n), do: Enum.sort(graph)
  def sort_for(graph, :s), do: graph |> Enum.sort() |> Enum.reverse()
  def sort_for(graph, :w) do
    graph |> Enum.sort(fn {{i1, j1}, val1}, {{i2, j2}, val2} -> j1 <= j2 end)
  end
  def sort_for(graph, :e) do
    graph |> Enum.sort(fn {{i1, j1}, val1}, {{i2, j2}, val2} -> j1 >= j2 end)
  end

  def key_for({i, j}, :n), do: {i - 1, j}
  def key_for({i, j}, :s), do: {i + 1, j}
  def key_for({i, j}, :w), do: {i, j - 1}
  def key_for({i, j}, :e), do: {i, j + 1}

  def tilt(graph, {i, j}, val, dir) do
    target_key = key_for({i, j}, dir)
    target = graph[target_key]
    if val == "O" and target == "." do
      graph
      |> Map.put(target_key, "O")
      |> Map.put({i, j}, ".")
    else
      graph
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.codepoints(line) end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line |> Enum.with_index() |> Enum.map(fn {val, j} -> {i, j, val} end)
    end)
    |> Enum.reduce(%{}, fn {i, j, val}, acc ->
      Map.put(acc, {i, j}, val)
    end)
  end
end

Main.main() |> IO.puts()

# 64 - input-small.txt
# 96447 - input-large.txt answer
