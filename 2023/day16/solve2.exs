defmodule Main do

  def main() do
    #graph = "input-small.txt" |> parse_input()
    graph = "input-large.txt" |> parse_input()
    max_i = graph |> Enum.map(fn {{i, _j}, _val} -> i end) |> Enum.max()
    max_j = graph |> Enum.map(fn {{_i, j}, _val} -> j end) |> Enum.max()

    start_points = Enum.flat_map(0..max_i, fn i -> [{{i, 0}, :e}, {{i, max_j}, :w}] end) ++
      Enum.flat_map(0..max_j, fn j -> [{{0, j}, :s}, {{max_i, j}, :n}] end)

    Enum.map(start_points, fn step ->
      graph |> walk(step) |> score()
    end)
    |> Enum.max()
  end

  def score(visited), do: visited |> Enum.map(fn {point, _dir} -> point end) |> Enum.uniq() |> length()

  def walk(graph) do
    walk(graph, [{{0, 0}, :e}], MapSet.new())
  end

  def walk(graph, start) when is_tuple(start) do
    walk(graph, [start], MapSet.new())
  end

  def walk(_graph, [], visited), do: visited

  def walk(graph, [step | steps ], visited) do
    {point, dir} = step
    visited = MapSet.put(visited, step)
    val = graph[point]
    next_p = [next_point(point, dir)]
    next_steps = case val do
      "." -> next_p
      "|" ->
        if dir in [:e, :w] do
          [n(point), s(point)]
        else
          next_p
        end
      "-" ->
        if dir in [:n, :s] do
          [w(point), e(point)]
        else
          next_p
        end
      "/" ->
        case dir do
          :e -> [n(point)]
          :w -> [s(point)]
          :n -> [e(point)]
          :s -> [w(point)]
        end
      "\\" ->
        case dir do
          :e -> [s(point)]
          :w -> [n(point)]
          :n -> [w(point)]
          :s -> [e(point)]
        end
      _ -> []
    end
    next_steps = Enum.filter(next_steps, fn {p, dir} ->
      graph[p] && !MapSet.member?(visited, {p, dir})
    end)
    walk(graph, next_steps ++ steps, visited)
  end

  def next_point(point, dir) do
    case dir do
      :e -> e(point)
      :w -> w(point)
      :n -> n(point)
      :s -> s(point)
    end
  end

  def n({i, j}), do: {{i - 1, j}, :n}
  def s({i, j}), do: {{i + 1, j}, :s}
  def e({i, j}), do: {{i, j + 1}, :e}
  def w({i, j}), do: {{i, j - 1}, :w}

  #def get_next_steps(graph)

  def parse_input(path) do
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
  end
end

Main.main() |> IO.puts()

# 51 - input-small.txt answer
# 7521 - input-large.txt answer
