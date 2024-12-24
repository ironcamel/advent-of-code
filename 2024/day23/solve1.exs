defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")

    graph
    |> Map.keys()
    |> Enum.filter(fn a -> MapSet.size(graph[a]) >= 2 end)
    |> Enum.reduce([], fn a, acc ->
      neighbors = graph[a]

      for b <- neighbors, c <- neighbors, b != c do
        {b, c}
      end
      |> Enum.filter(fn {b, c} ->
        Enum.any?([a, b, c], fn d -> d =~ ~r/^t/ end) && c in graph[b]
      end)
      |> Enum.map(fn {b, c} -> MapSet.new([a, b, c]) end)
      |> then(fn triples -> triples ++ acc end)
    end)
    |> Enum.uniq()
    |> length()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, graph ->
      [a, b] = String.split(line, "-")

      graph
      |> put_in([Access.key(a, %{}), b], true)
      |> put_in([Access.key(b, %{}), a], true)
    end)
    |> Enum.map(fn {k, v} -> {k, MapSet.new(Map.keys(v))} end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 7 - input-small.txt answer
# 1358 - input-large.txt answer
