defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")
    nodes = Map.keys(graph)

    common_edges =
      for a <- nodes, b <- nodes, a != b do
        {graph[a] |> MapSet.intersection(graph[b]) |> MapSet.size(), {a, b}}
      end

    {max, _} = Enum.max(common_edges)

    common_edges
    |> Enum.filter(fn {cnt, _} -> cnt == max end)
    |> Enum.map(fn {_, {a, b}} -> Enum.sort([a, b]) end)
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.chunk_by(fn [a, _b] -> a end)
    |> Enum.map(fn chunk -> {length(chunk), chunk} end)
    |> Enum.max()
    |> then(fn {_, pairs} ->
      pairs |> List.flatten() |> Enum.uniq() |> Enum.sort() |> Enum.join(",")
    end)
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
    |> Enum.map(fn {k, v} -> {k, MapSet.new([k | Map.keys(v)])} end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# cl,ei,fd,hc,ib,kq,kv,ky,rv,vf,wk,yx,zf - input-large.txt answer
