defmodule Main do
  def main() do
    {graph, steps} = parse_input("input-large.txt")

    steps
    |> Stream.cycle()
    |> Stream.scan("AAA", fn dir, node -> graph[node][dir] end)
    |> Enum.find_index(fn node -> node == "ZZZ" end)
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

# 6 - input-small.txt answer
# 20093 - input-large.txt answer
