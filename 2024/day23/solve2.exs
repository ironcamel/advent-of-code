defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")

    sets =
      graph
      |> Enum.map(fn {k, v} ->
        {k, MapSet.new([k | Map.keys(v)])}
      end)
      |> Map.new()

    keys = Map.keys(graph)

    max =
      for a <- keys, b <- keys, a != b do
        MapSet.intersection(sets[a], sets[b]) |> MapSet.size()
      end
      |> Enum.max()

    for a <- keys, b <- keys, a != b do
      {a, b}
    end
    |> Enum.filter(fn {a, b} ->
      MapSet.intersection(sets[a], sets[b]) |> MapSet.size() == max
    end)
    |> Enum.map(fn {a, b} -> Enum.sort([a, b]) end)
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.chunk_by(fn [a, _b] -> a end)
    |> Enum.map(fn chunk -> {length(chunk), chunk} end)
    |> Enum.sort()
    |> Enum.reverse()
    |> hd()
    |> then(fn {_, pairs} ->
      pairs |> List.flatten |> Enum.uniq |> Enum.sort |> Enum.join(",")
    end)
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

# cl,ei,fd,hc,ib,kq,kv,ky,rv,vf,wk,yx,zf - input-large.txt answer
