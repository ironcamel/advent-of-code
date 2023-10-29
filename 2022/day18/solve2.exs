defmodule Main do
  def go() do
    rows = "input-large.txt" |> parse_input

    points =
      Enum.reduce(rows, %{}, fn {x, y, z}, acc ->
        put_in(acc, Enum.map([x, y, z], &Access.key(&1, %{})), 1)
      end)

    air = gen_air(points, rows)

    rows
    |> Enum.map(fn point -> count_air(air, point) end)
    |> Enum.sum()
  end

  def gen_air(points, rows) do
    min_max = get_min_max(rows)
    dfs_air(points, min_max, %{}, {0, 0, 0})
  end

  def dfs_air(points, min_max, air, {x, y, z}) do
    air = put_in(air, Enum.map([x, y, z], &Access.key(&1, %{})), 1)
    %{max_x: max_x, max_y: max_y, max_z: max_z} = min_max
    max_x = max_x + 1
    max_y = max_y + 1
    max_z = max_z + 1

    [{x + 1, y, z}, {x - 1, y, z}, {x, y + 1, z}, {x, y - 1, z}, {x, y, z + 1}, {x, y, z - 1}]
    |> Enum.filter(fn {x, y, z} -> x >= -1 and y >= -1 and z >= -1 end)
    |> Enum.filter(fn {x, y, z} -> x <= max_x and y <= max_y and z <= max_z end)
    |> Enum.filter(fn {x, y, z} -> !air[x][y][z] && !points[x][y][z] end)
    |> Enum.reduce(air, fn point, acc -> dfs_air(points, min_max, acc, point) end)
  end

  def count_air(air, {x, y, z}) do
    num =
      0 +
        (air[x][y][z + 1] || 0) +
        (air[x][y][z - 1] || 0) +
        (air[x][y + 1][z] || 0) +
        (air[x][y - 1][z] || 0) +
        (air[x + 1][y][z] || 0) +
        (air[x - 1][y][z] || 0)

    num
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

  def get_min_max(rows) do
    min_x = rows |> Enum.map(fn {x, _y, _z} -> x end) |> Enum.min()
    max_x = rows |> Enum.map(fn {x, _y, _z} -> x end) |> Enum.max()
    min_y = rows |> Enum.map(fn {_x, y, _z} -> y end) |> Enum.min()
    max_y = rows |> Enum.map(fn {_x, y, _z} -> y end) |> Enum.max()
    min_z = rows |> Enum.map(fn {_x, _y, z} -> z end) |> Enum.min()
    max_z = rows |> Enum.map(fn {_x, _y, z} -> z end) |> Enum.max()
    %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, min_z: min_z, max_z: max_z}
  end

  def print(points, rows) when is_list(rows), do: print(points, get_min_max(rows))

  def print(points, min_max) do
    %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, min_z: min_z, max_z: max_z} =
      min_max

    IO.inspect([min_x, max_x, min_y, max_y, min_z, max_z])

    for z <- min_z..max_z do
      IO.puts("--- z: #{z}")

      for y <- min_y..max_y do
        IO.write(String.pad_leading("#{y}", 2))

        for x <- min_x..max_x do
          if points[x][y][z] do
            IO.write("#")
          else
            IO.write(" ")
          end
        end

        IO.puts("")
      end
    end

    IO.puts("--- done")
  end
end

IO.puts(Main.go())

# 58 - input-small.txt answer
# 2090 - input-large.txt answer
