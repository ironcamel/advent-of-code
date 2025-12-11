defmodule Main do
  def main() do
    "input-large.txt" |> parse_input() |> dfs("you")
  end

  def dfs(_graph, "out"), do: 1

  def dfs(graph, node) do
    graph[node] |> Enum.map(fn n -> dfs(graph, n) end) |> Enum.sum()
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

# 5 - input-small.txt anser
# 764 - input-large.txt answer
