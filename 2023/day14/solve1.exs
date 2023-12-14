defmodule Main do

  def main() do
    graph = "input-large.txt" |> parse_input
    #graph = "input-small.txt" |> parse_input
    #graph = "foo.txt" |> parse_input
    #

    #num_rows = graph |> Enum.map(fn {i, j} -> i end) |> Enum.max() |> then(&(&1 + 1))
    max_i = graph |> Enum.map(fn {{i, j}, _} -> i end) |> Enum.max()
    num_rows = max_i + 1

    tilt(graph)
    #|> print(max_i)
    |> Enum.map(fn {{i, j}, %{val: val}} ->
      if val == "O" do
        num_rows - i
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def tilt(graph) do
    new_graph =
      graph
      |> Enum.sort()
      |> Enum.reduce(graph, fn {{i, j}, %{val: val}} = node, acc ->
        tilt(acc, {i, j}, val)
      end)
    if new_graph == graph do
      graph
    else
      tilt(new_graph)
    end
  end

  def tilt(graph, {i, j} = node, val) do
    target = graph[{i - 1, j}] && graph[{i - 1, j}].val
    if val == "O" and target == "." do
      graph
      |> Map.put({i - 1, j}, %{val: "O"})
      |> Map.put({i, j}, %{val: "."})
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
      Map.put(acc, {i, j}, %{val: val, i: i, j: j})
    end)
  end

  def print(graph, max_i) do
    0..max_i
    |> Enum.each(fn i ->
      graph |> Enum.filter(fn {{i2, j}, _} -> i2 == i end) |> Enum.sort()
      |> Enum.map(fn {_, %{val: val}} -> val end) |> Enum.join() |> IO.puts
    end)
    graph
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> Main.p()

# 108614 - input-large.txt answer
