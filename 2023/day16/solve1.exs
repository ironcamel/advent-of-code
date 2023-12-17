defmodule Main do

  def main() do
    "input-large.txt"
    #"input-small.txt"
    |> parse_input()
    |> walk()
    |> Enum.map(fn {point, _dir} -> point end)
    |> Enum.uniq()
    |> length()
  end

  def walk(graph) do
    walk(graph, [{{0, 0}, :e}], MapSet.new())
  end

  def walk(_graph, [], visited), do: visited

  def walk(graph, [step | steps ], visited) do
    {point, dir} = step
    #p step
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

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> IO.puts()

# 46 - input-small.txt answer
# 7236 - input-large.txt answer
