defmodule Main do
  def main() do
    #graph = "input-small.txt" |> parse_input()
    graph = parse_input("input-large.txt")

    graph
    |> Map.keys()
    |> Enum.filter(fn a ->
      graph[a] |> Map.keys() |> length() >= 2
    end)
    |> Enum.reduce([], fn a, acc ->
      neighbors = Map.keys(graph[a])

      for b <- neighbors, c <- neighbors, b != c do
        {b, c}
      end
      |> Enum.filter(fn {b, c} ->
        Enum.any?([a, b, c], fn d -> d =~ ~r/^t/ end) && graph[b][c]
      end)
      |> Enum.map(fn {b, c} ->
        MapSet.new([a, b, c])
      end)
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
      [a, b] = line |> String.split("-")

      graph =
        if graph[a] do
          put_in(graph[a][b], true)
        else
          Map.put(graph, a, %{b => true})
        end

      if graph[b] do
        put_in(graph[b][a], true)
      else
        Map.put(graph, b, %{a => true})
      end
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 7 - input-small.txt answer
# 1358 - input-large.txt answer
