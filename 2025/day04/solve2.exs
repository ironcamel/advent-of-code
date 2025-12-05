defmodule Main do
  @unit_circle [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  def main() do
    "input-large.txt" |> parse_input() |> reduce()
  end

  def reduce(grid, count \\ 0) do
    rolls =
      grid
      |> Enum.filter(fn {point, val} -> val == "@" and can_remove(grid, point) end)
      |> Enum.map(fn {point, _val} -> point end)

    if length(rolls) > 0 do
      reduce(Map.drop(grid, rolls), count + length(rolls))
    else
      count
    end
  end

  def can_remove(grid, point) do
    Enum.count(@unit_circle, fn p -> grid[add_points(p, point)] == "@" end) < 4
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
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 43 - input-small.txt answer
# 8701 - input-large.txt answer
