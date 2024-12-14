defmodule Main do
  @height 103
  @width 101
  @mid_i div(@height, 2)
  @mid_j div(@width, 2)

  def main() do
    "input-large.txt"
    |> parse_input()
    |> move_robots(100)
    |> Enum.flat_map(fn {p, robots} -> List.duplicate(p, length(robots)) end)
    |> Enum.reject(fn {i, j} -> j == @mid_j or i == @mid_i end)
    |> Enum.map(fn {i, j} ->
      cond do
        i < @mid_i and j < @mid_j -> 1
        i < @mid_i and j > @mid_j -> 2
        i > @mid_i and j < @mid_j -> 3
        true -> 4
      end
    end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.product()
  end

  def move_robots(grid, times) do
    grid
    |> Enum.flat_map(fn {{i, j}, robots} ->
      Enum.map(robots, fn {x, y} ->
        i2 = rem(i + y * times, @height)
        j2 = rem(j + x * times, @width)
        i2 = if i2 < 0, do: @height + i2, else: i2
        j2 = if j2 < 0, do: @width + j2, else: j2
        [j2, i2, x, y]
      end)
    end)
    |> Enum.reduce(%{}, fn [j, i, x, y], acc ->
      robots = acc[{i, j}] || []
      Map.put(acc, {i, j}, [{x, y} | robots])
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ~r/p=(.+),(\S+) v=(.+),(.+)/ |> Regex.run(line) |> tl() |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce(%{}, fn [j, i, x, y], acc ->
      robots = acc[{i, j}] || []
      Map.put(acc, {i, j}, [{x, y} | robots])
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 230436441 - input-large.txt answer
