defmodule Main do
  def main() do
    {graph, num_rows} = parse_input("input-large.txt")

    tilt(graph)
    |> Enum.filter(fn {_key, val} -> val == "O" end)
    |> Enum.map(fn {{i, _j}, _val} -> num_rows - i end)
    |> Enum.sum()
  end

  def tilt(graph) do
    new_graph =
      graph
      |> Enum.sort()
      |> Enum.reduce(graph, fn {key, val}, acc ->
        tilt(acc, key, val)
      end)

    if new_graph == graph, do: graph, else: tilt(new_graph)
  end

  def tilt(graph, {i, j}, val) do
    target = graph[{i - 1, j}]

    if val == "O" and target == "." do
      graph |> Map.put({i - 1, j}, "O") |> Map.put({i, j}, ".")
    else
      graph
    end
  end

  def parse_input(path) do
    lines =
      path
      |> File.read!()
      |> String.split("\n", trim: true)

    graph =
      lines
      |> Enum.map(&String.codepoints/1)
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

# 136 - input-small.txt answer
# 108614 - input-large.txt answer
