defmodule Main do
  def go() do
    # "input-small.txt"
    rows =
      "input-large.txt"
      |> parse_input

    points =
      Enum.reduce(rows, %{}, fn {x, y, z}, acc ->
        put_in(acc, Enum.map([x, y, z], &Access.key(&1, %{})), 1)
      end)

    for point <- rows do
      6 - num_neighbors(points, point)
    end
    |> Enum.sum()
  end

  def num_neighbors(points, {x, y, z}) do
    0 +
      (points[x][y][z + 1] || 0) +
      (points[x][y][z - 1] || 0) +
      (points[x][y + 1][z] || 0) +
      (points[x][y - 1][z] || 0) +
      (points[x + 1][y][z] || 0) +
      (points[x - 1][y][z] || 0)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))
      |> List.to_tuple()
    end)
  end
end

IO.puts(Main.go())

# 64 - input-small.txt answer
# 3526 - input-large.txt answer
