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

  def dir_vector(dir) do
    case dir do
      :n -> {-1, 0}
      :s -> {1, 0}
      :e -> {0, 1}
      :w -> {0, -1}
    end
  end

  def turn_right(dir) do
    case dir do
      :n -> :e
      :s -> :w
      :e -> :s
      :w -> :n
    end
  end

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
