defmodule Main do
  def main() do
    # "input-large.txt"
    #{freqs, graph, max_i, max_j} = "input-small.txt" |> parse_input()
    {freqs, graph, max_i, max_j} = "input-large.txt" |> parse_input()
    #{freqs, graph, max_i, max_j} = "foo.txt" |> parse_input()

    freqs
    #|> dbg
    |> Enum.flat_map(fn {freq, points} ->
      gen_antinodes(points, max_i, max_j, [])
    end)
    |> Enum.uniq()
    |> Enum.count(fn {i, j} -> i >= 0 and i <= max_i and j >= 0 and j <= max_j end)
  end

  def gen_antinodes([], _, _, acc), do: acc

  def gen_antinodes([point1 | points], max_i, max_j, acc) do
    #dbg{point1, points}
    {i1, j1} = point1
    ants =
      points
      |> Enum.flat_map(fn {i2, j2} = point2 ->
        {dist_i, dist_j} = get_dist(point1, point2)
        {i3, i4} =
          if i1 <= i2 do
            {Enum.to_list(i1..0//-dist_i), Enum.to_list(i2..max_i//dist_i)}
          else
            {Enum.to_list(i1..max_i//dist_i), Enum.to_list(i2..0//-dist_i)}
          end
        {j3, j4} =
          if j1 <= j2 do
            {Enum.to_list(j1..0//-dist_j), Enum.to_list(j2..max_j//dist_j)}
          else
            {Enum.to_list(j1..max_j//dist_j), Enum.to_list(j2..0//-dist_j)}
          end
        #[{i3, j3}, {i4, j4}]
        Enum.zip(i3, j3) ++ Enum.zip(i4, j4)
      end)
    gen_antinodes(points, max_i, max_j, acc ++ ants)
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

# 34 - input-small.txt answer
