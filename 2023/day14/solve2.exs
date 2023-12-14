defmodule Main do
  def main() do
    {graph, num_rows} = parse_input("input-large.txt")
    {graph, cnt1, cnt2} = find_cycle(graph)
    iterations_left = rem(1_000_000_000 - cnt1, cnt2 - cnt1)

    1..iterations_left
    |> Enum.reduce(graph, fn _, acc -> tilt(acc) end)
    |> score(num_rows)
  end

  def score(graph, num_rows) do
    graph
    |> Enum.filter(fn {_key, val} -> val == "O" end)
    |> Enum.map(fn {{i, _j}, _val} -> num_rows - i end)
    |> Enum.sum()
  end

  def find_cycle(graph), do: find_cycle(graph, 1, %{graph => 0})

  def find_cycle(graph, cnt, seen) do
    new_graph = tilt(graph)
    seen_cnt = Map.get(seen, new_graph)

    if seen_cnt do
      {new_graph, seen_cnt, cnt}
    else
      find_cycle(new_graph, cnt + 1, Map.put(seen, new_graph, cnt))
    end
  end

  def tilt(graph) do
    [:n, :w, :s, :e] |> Enum.reduce(graph, fn dir, acc -> tilt(acc, dir) end)
  end

  def tilt(graph, dir) do
    new_graph =
      graph
      |> sort_for(dir)
      |> Enum.reduce(graph, fn {key, val}, acc ->
        tilt(acc, key, val, dir)
      end)

    if Map.equal?(new_graph, graph) do
      graph
    else
      tilt(new_graph, dir)
    end
  end

  def tilt(graph, {i, j}, val, dir) do
    target_key = key_for({i, j}, dir)
    target = graph[target_key]

    if val == "O" and target == "." do
      graph |> Map.put(target_key, "O") |> Map.put({i, j}, ".")
    else
      graph
    end
  end

  def sort_for(graph, :n), do: Enum.sort(graph)
  def sort_for(graph, :s), do: graph |> Enum.sort() |> Enum.reverse()

  def sort_for(graph, :w) do
    graph |> Enum.sort(fn {{_i1, j1}, _val1}, {{_i2, j2}, _val2} -> j1 <= j2 end)
  end

  def sort_for(graph, :e) do
    graph |> Enum.sort(fn {{_i1, j1}, _val1}, {{_i2, j2}, _val2} -> j1 >= j2 end)
  end

  def key_for({i, j}, :n), do: {i - 1, j}
  def key_for({i, j}, :s), do: {i + 1, j}
  def key_for({i, j}, :w), do: {i, j - 1}
  def key_for({i, j}, :e), do: {i, j + 1}

  def parse_input(path) do
    lines =
      path
      |> File.read!()
      |> String.split("\n", trim: true)

    graph =
      lines
      |> Enum.map(fn line -> String.codepoints(line) end)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line |> Enum.with_index() |> Enum.map(fn {val, j} -> {i, j, val} end)
      end)
      |> Enum.reduce(%{}, fn {i, j, val}, acc ->
        Map.put(acc, {i, j}, val)
      end)

    {graph, length(lines)}
  end
end

Main.main() |> IO.puts()

# 64 - input-small.txt
# 96447 - input-large.txt answer
