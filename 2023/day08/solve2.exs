Mix.install([:math])

defmodule Main do
  def main() do
    {graph, steps} = parse_input("input-large.txt")

    graph
    |> Map.keys()
    |> Enum.filter(fn node -> node =~ ~r/..A/ end)
    |> Enum.map(fn node -> search(graph, steps, node) end)
    |> Enum.reduce(fn x, acc -> Math.lcm(x, acc) end)
  end

  def search(graph, steps, start) do
    steps
    |> Stream.cycle()
    |> Stream.scan(start, fn dir, node -> graph[node][dir] end)
    |> Enum.find_index(fn node -> node =~ ~r/..Z/ end)
    |> then(&(&1 + 1))
  end

  def parse_input(path) do
    lines = path |> File.read!() |> String.split("\n", trim: true)
    [steps | lines] = lines

    graph =
      lines
      |> Enum.map(fn line -> Regex.run(~r/(...) = \((...), (...)\)/, line) |> tl() end)
      |> Enum.reduce(%{}, fn [node, l, r], acc -> Map.put(acc, node, %{"L" => l, "R" => r}) end)

    {graph, String.codepoints(steps)}
  end
end

Main.main() |> IO.puts()

# 6 - input-small2.txt answer
# 22103062509257 - input-large.txt answer
