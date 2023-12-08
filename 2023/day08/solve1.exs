defmodule Main do
  def main() do
    {graph, steps} = "input-large.txt" |> parse_input
    search(graph, steps, steps, "AAA", 1)
  end

  def search(_graph, _steps, _orig_steps, "ZZZ", cnt), do: cnt - 1

  def search(graph, [], orig_steps, node, cnt) do
    search(graph, orig_steps, orig_steps, node, cnt)
  end

  def search(graph, [dir | steps], orig_steps, node, cnt) do
    next = graph[node][dir]
    search(graph, steps, orig_steps, next, cnt + 1)
  end

  def parse_input(path) do
    lines = path |> File.read!() |> String.split("\n", trim: true)

    [steps | lines] = lines
    steps = String.codepoints(steps)

    graph =
      lines
      |> Enum.map(fn line ->
        Regex.run(~r/(...) = \((...), (...)\)/, line) |> tl()
      end)
      |> Enum.reduce(%{}, fn [node, l, r], acc ->
        Map.put(acc, node, %{"L" => l, "R" => r})
      end)

    {graph, steps}
  end
end

Main.main() |> IO.puts()

# 6 - input-small.txt answer
# 20093 - input-large.txt answer
