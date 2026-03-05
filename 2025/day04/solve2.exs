defmodule Main do
  @unit_circle [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  def main() do
    grid = parse_input("input-large.txt")
    MapSet.size(grid) - MapSet.size(reduce(grid))
  end

  def reduce(grid) do
    rolls = Enum.filter(grid, fn point -> can_remove(grid, point) end)

    if length(rolls) > 0 do
      grid |> MapSet.difference(MapSet.new(rolls)) |> reduce()
    else
      grid
    end
  end

  def can_remove(grid, point) do
    Enum.count(@unit_circle, fn p -> MapSet.member?(grid, add_points(p, point)) end) < 4
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

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
      |> Enum.filter(fn {_pos, val} -> val == "@" end)
      |> Enum.map(fn {pos, _val} -> pos end)
    end)
    |> MapSet.new()
  end
end

Main.main() |> IO.puts()

# 43 - input-small.txt answer
# 8701 - input-large.txt answer
