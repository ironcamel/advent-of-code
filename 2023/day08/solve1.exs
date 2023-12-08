defmodule Main do

  def main() do
    #{graph, steps} = "input-small.txt" |> parse_input
    {graph, steps} = "input-large.txt" |> parse_input

    search(graph, steps, steps, "AAA", 1)
  end

  #def search(graph, steps, _, _, 9), do: "oops"

  def search(graph, steps, orig_steps, "ZZZ", cnt), do: cnt - 1

  def search(graph, [], orig_steps, node, cnt), do: search(graph, orig_steps, orig_steps, node, cnt)

  def search(graph, [ dir | steps], orig_steps, node, cnt) do
    next = graph[node][dir]
    search(graph, steps, orig_steps, next, cnt+1)
  end

  def parse_input(path) do
    lines =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)

    [steps | lines] = lines
    steps = String.codepoints(steps)

    graph =
      lines
      |> Enum.map(fn line ->
        Regex.run(~r/(...) = \((...), (...)\)/, line) |> tl
      end)
      |> Enum.reduce(%{}, fn [a, b, c], acc ->
        Map.put(acc, a, %{"L" => b, "R" => c})
      end)

    {graph, steps}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> IO.inspect()
