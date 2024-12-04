defmodule Main do
  @ms [{"M", "S"}, {"S", "M"}]

  def main() do
    grid = parse_input("input-large.txt")

    grid
    |> Enum.filter(fn {_, val} -> val == "A" end)
    |> Enum.count(fn {{i, j}, _val} -> check_a(grid, i, j) end)
  end

  def check_a(grid, i, j) do
    {grid[{i - 1, j - 1}], grid[{i + 1, j + 1}]} in @ms and
      {grid[{i - 1, j + 1}], grid[{i + 1, j - 1}]} in @ms
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

# 9 - input-small2.txt answer
# 1998 - input-large.txt answer
