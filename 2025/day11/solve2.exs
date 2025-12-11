Mix.install([:memoize])

defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")

    dfs(graph, "svr", "dac") * dfs(graph, "dac", "fft") * dfs(graph, "fft", "out") +
      dfs(graph, "svr", "fft") * dfs(graph, "fft", "dac") * dfs(graph, "dac", "out")
  end

  def dfs(graph, node, target)
  def dfs(_graph, node, target) when node == target, do: 1

  def dfs(graph, node, target) do
    Memoize.Cache.get_or_run({__MODULE__, :resolve, [node, target]}, fn ->
      (graph[node] || []) |> Enum.map(fn n -> dfs(graph, n, target) end) |> Enum.sum()
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [k, vals] = String.split(line, ": ")
      {k, String.split(vals)}
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 2 - input-small2.txt answer
# 462444153119850 - input-large.txt answer
