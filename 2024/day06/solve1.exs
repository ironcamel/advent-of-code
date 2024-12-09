defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")
    {init_pos, _} = Enum.find(graph, fn {_k, v} -> v == "^" end)
    graph = Map.put(graph, init_pos, ".")
    walk(graph, init_pos)
  end

  def walk(graph, pos, dir \\ :n, visited \\ MapSet.new()) do
    visited = MapSet.put(visited, pos)
    next_pos = add_points(pos, dir_vector(dir))

    case graph[next_pos] do
      "." -> walk(graph, next_pos, dir, visited)
      "#" -> walk(graph, pos, turn_right(dir), visited)
      _ -> MapSet.size(visited)
    end
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def dir_vector(:n), do: {-1, 0}
  def dir_vector(:s), do: {1, 0}
  def dir_vector(:e), do: {0, 1}
  def dir_vector(:w), do: {0, -1}

  def turn_right(:n), do: :e
  def turn_right(:s), do: :w
  def turn_right(:e), do: :s
  def turn_right(:w), do: :n

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

# 41 - input-small.txt answer
# 5177 - input-large.txt answer