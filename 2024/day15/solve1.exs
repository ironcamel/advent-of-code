defmodule Main do

  def main() do
    # "input-large.txt"
    #"input-small.txt"
    #{grid, moves} = parse_input("foo.txt")
    #{grid, moves} = parse_input("foo2.txt")
    #{grid, moves} = parse_input("input-small.txt")
    {grid, moves} = parse_input("input-large.txt")
    max_ij = grid |> Map.keys() |> Enum.max()
    robot_pos = grid |> Enum.find(fn {_, val} -> val == "@" end) |> elem(0)
    print(grid)
    get_boxes(grid, max_ij, ">", robot_pos)

    moves
    #|> Enum.take(13)
    |> Enum.reduce({grid, robot_pos}, fn dir, {grid, robot} ->
      #IO.puts(dir)

      {grid, robot} = move(grid, max_ij, dir, robot)
      #print(grid)
      {grid, robot}
    end)
    |> then(fn {grid, _} -> grid end)
    |> Enum.map(fn
      {{i, j}, "O"} -> 100 * i + j
      _ -> 0
    end)
    |> Enum.sum()

  end

  def move(grid, max_ij, dir, robot) do
    boxes = get_boxes(grid, max_ij, dir, robot)
    move(grid, max_ij, dir, robot, boxes)
  end

  def move(grid, max_ij, dir, robot, boxes) do
    #{hi, hj} = if length(boxes), do: hd(boxes), else: robot
    head = if length(boxes) > 0, do: hd(boxes), else: robot
    object = grid[add_points(vector_for(dir), head)]
    if object == "#" do
      {grid, robot}
    else
      vector = vector_for(dir)
      new_robot = add_points(robot, vector)

      boxes
      |> Enum.reduce(grid, fn box, acc -> Map.put(acc, add_points(box, vector), "O") end)
      |> Map.put(new_robot, "@")
      |> Map.delete(robot)
      |> then(fn grid -> {grid, new_robot} end)
    end
  end

  def range_for("<", {i, j}, _max_ij), do: j-1..0//-1
  def range_for(">", {i, j}, {_max_i, max_j}), do: j+1..max_j
  def range_for("^", {i, j}, _max_ij), do: i-1..0//-1
  def range_for("v", {i, j}, {max_i, _max_j}), do: i+1..max_i

  def vector_for("<"), do: {0, -1}
  def vector_for(">"), do: {0, 1}
  def vector_for("^"), do: {-1, 0}
  def vector_for("v"), do: {1, 0}

  def apply_vector(dir, start_pos, max_ij) do
    dir
    |> range_for(start_pos, max_ij)
    |> Enum.reduce([], fn _, acc ->
      [add_points(List.first(acc, start_pos), vector_for(dir)) | acc]
    end)
  end

  def get_boxes(grid, max_ij, dir, {ri, rj} = robot) do
    dir
    |> apply_vector(robot, max_ij)
    |> Enum.reverse()
    |> Enum.take_while(fn p -> grid[p] == "O" end)
    |> Enum.reverse()
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def print(grid) do
    {max_i, max_j} = grid |> Map.keys() |> Enum.max()
    for i <- 0..max_i do
      0..max_j
      |> Enum.map(fn j -> grid[{i, j}] || " " end)
      |> Enum.join()
      |> IO.puts()
    end

    grid
  end

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.split("\n\n")

    grid =
      part1
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reject(fn {val, _j} -> val == "." end)
        |> Enum.map(fn {val, j} -> {{i, j}, val} end)
      end)
      |> Map.new()

    moves = part2 |> String.codepoints() |> Enum.reject(fn c -> c == "\n" end)

    {grid, moves}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 10092 - input-small.txt answer
# 1436690 - input-large.txt answer
