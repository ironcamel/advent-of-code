defmodule Main do
  def main() do
    graph = parse_input("input-large.txt")
    {init_pos, _} = Enum.find(graph, fn {_k, v} -> v == "^" end)
    graph = Map.put(graph, init_pos, ".")

    graph
    |> walk(init_pos)
    |> Enum.map(fn {pos, _dir} -> pos end)
    |> Enum.uniq()
    |> Enum.reject(fn pos -> pos == init_pos end)
    |> Enum.count(fn pos ->
      new_graph = Map.put(graph, pos, "#")
      walk(new_graph, init_pos) == :found_loop
    end)
  end

  def walk(graph, pos, dir \\ :n, visited \\ MapSet.new()) do
    if MapSet.member?(visited, {pos, dir}) do
      :found_loop
    else
      visited = MapSet.put(visited, {pos, dir})
      next_pos = add_points(pos, dir_vector(dir))

      case graph[next_pos] do
        "." -> walk(graph, next_pos, dir, visited)
        "#" -> walk(graph, pos, turn_right(dir), visited)
        _ -> visited
      end
    end
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def dir_vector(dir) do
    case dir do
      :n -> {-1, 0}
      :e -> {0, 1}
      :s -> {1, 0}
      :w -> {0, -1}
    end
  end

  def turn_right(dir) do
    case dir do
      :n -> :e
      :e -> :s
      :s -> :w
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

# 6 - input-small.txt answer
# 1686 - input-large.txt answer
