defmodule Main do
  def main() do
    {graph, empty_rows, empty_cols} = parse_input("input-large.txt")

    galaxies =
      graph
      |> Enum.filter(fn {_key, val} -> val == "#" end)
      |> Enum.map(fn {key, _c} -> key end)
      |> Enum.sort()

    for(g1 <- galaxies, g2 <- galaxies, do: {g1, g2})
    |> Enum.map(fn pair -> pair |> Tuple.to_list() |> Enum.sort() end)
    |> Enum.filter(fn [a, b] -> a != b end)
    |> Enum.uniq()
    |> Enum.map(fn [{ai, aj}, {bi, bj}] ->
      [ai, bi] = Enum.sort([ai, bi])
      x_diff = bi - ai
      x_range = ai..bi
      [aj, bj] = Enum.sort([aj, bj])
      y_diff = bj - aj
      y_range = aj..bj
      num_rows = empty_rows |> Enum.count(fn i -> i in x_range end)
      num_cols = empty_cols |> Enum.count(fn j -> j in y_range end)
      x_diff + y_diff + num_rows + num_cols
    end)
    |> Enum.sum()
  end

  def parse_input(path) do
    lines = path |> File.read!() |> String.trim() |> String.split("\n", trim: true)

    graph =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line |> String.codepoints() |> Enum.with_index() |> Enum.map(fn {c, j} -> {i, j, c} end)
      end)
      |> Enum.reduce(%{}, fn {i, j, c}, acc -> Map.put(acc, {i, j}, c) end)

    empty_rows =
      lines
      |> Enum.with_index()
      |> Enum.filter(fn {row, _i} -> row =~ ~r/^\.+$/ end)
      |> Enum.map(fn {_row, i} -> i end)

    empty_cols =
      lines
      |> Enum.map(&String.codepoints/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.with_index()
      |> Enum.filter(fn {col, _j} -> Enum.all?(col, &(&1 == ".")) end)
      |> Enum.map(fn {_col, j} -> j end)

    {graph, empty_rows, empty_cols}
  end
end

Main.main() |> IO.puts()

# 374 - input-small.txt answer
# 10490062 - input-large.txt answer
