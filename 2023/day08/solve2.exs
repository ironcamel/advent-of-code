Mix.install([:math])

defmodule Main do
  def main() do
    {graph, steps} = parse_input("input-large.txt")

    graph
    |> Map.keys()
    |> Enum.filter(fn node -> node =~ ~r/..A/ end)
    |> Enum.map(fn node -> search(graph, steps, steps, node, 1) end)
    |> Enum.reduce(fn x, acc -> Math.lcm(x, acc) end)
  end

  def search(graph, [], orig_steps, node, cnt) do
    search(graph, orig_steps, orig_steps, node, cnt)
  end

  def search(graph, [dir | steps], orig_steps, node, cnt) do
    next = graph[node][dir]

    if next =~ ~r/..Z/ do
      cnt
    else
      search(graph, steps, orig_steps, next, cnt + 1)
    end
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

# 6 - input-small2.txt answer
# 22103062509257 - input-large.txt answer
