defmodule Main do
  def main() do
    {freqs, graph, max_i, max_j} = parse_input("input-large.txt")

    freqs
    |> Enum.flat_map(fn {freq, points} -> gen_antinodes(graph, freq, points, []) end)
    |> Enum.uniq()
    |> Enum.count(fn {i, j} -> i >= 0 and i <= max_i and j >= 0 and j <= max_j end)
  end

  def gen_antinodes(_graph, _freq, [], acc), do: acc

  def gen_antinodes(graph, freq, [point1 | points], acc) do
    #dbg{point1, points}
    {i1, j1} = point1
    ants =
      points
      |> Enum.flat_map(fn {i2, j2} = point2 ->
        {dist_i, dist_j} = get_dist(point1, point2)
        {i3, i4} =
          if i1 <= i2 do
            {i1 - dist_i, i2 + dist_i}
          else
            {i1 + dist_i, i2 - dist_i}
          end
        {j3, j4} =
          if j1 <= j2 do
            {j1 - dist_j, j2 + dist_j}
          else
            {j1 + dist_j, j2 - dist_j}
          end
        [{i3, j3}, {i4, j4}]
      end)
    gen_antinodes(graph, freq, points, acc ++ ants)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def get_dist({i1, j1}, {i2, j2}), do: {abs(i1 - i2), abs(j1 - j2)}

  def parse_input(path) do
    graph =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.map(fn {val, j} -> {{i, j}, val} end)
      end)
      |> Map.new()

    lines =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n", trim: true)

    max_i = length(lines) - 1
    max_j = (lines |> hd() |> String.length()) - 1

    ants =
      graph
      |> Enum.reduce(%{}, fn
        {_pos, "."}, acc -> acc
        {pos, val}, acc ->
          if acc[val] do
            Map.put(acc, val, [pos | acc[val]])
          else
            Map.put(acc, val, [pos])
          end
      end)

    {ants, graph, max_i, max_j}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 14 - input-small.txt answer
# 367 - input-large.txt answer
