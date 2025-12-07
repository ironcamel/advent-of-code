Mix.install([:memoize])

defmodule Main do
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}

  def main() do
    grid = parse_input("input-large.txt")
    {start, _} = Enum.find(grid, fn {_k, v} -> v == "S" end)
    search(grid, start)
  end

  def search(graph, node) do
    Memoize.Cache.get_or_run({__MODULE__, :resolve, [node]}, fn ->
      val = graph[node]

      case val do
        nil -> 1
        "^" -> search(graph, sw_of(node)) + search(graph, se_of(node))
        _ -> search(graph, add_points(node, @south))
      end
    end)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}
  def sw_of(p), do: p |> add_points(@south) |> add_points(@west)
  def se_of(p), do: p |> add_points(@south) |> add_points(@east)

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {val, j} -> {{i, j}, val} end)
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 40 - input-small.txt answer
# 48989920237096 - input-large.txt answer
