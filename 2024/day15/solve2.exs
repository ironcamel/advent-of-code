defmodule Main do
  def main() do
    {grid, moves} = parse_input("input-large.txt")
    # _max_ij = grid |> Map.keys() |> Enum.max()
    robot = grid |> Enum.find(fn {_, val} -> val == "@" end) |> elem(0)
    # grid |> Enum.sort()

    Enum.reduce(moves, {grid, robot}, fn dir, {grid, robot} ->
      move(grid, robot, dir)
    end)
    |> then(fn {grid, _} -> grid end)
    |> Enum.map(fn
      {{i, j}, "["} -> 100 * i + j
      _ -> 0
    end)
    |> Enum.sum()
  end

  def move(grid, robot, dir) when dir in ["<", ">"] do
    if can_move(grid, robot, dir) do
      move_sideways(grid, robot, dir)
    else
      {grid, robot}
    end
  end

  def move(grid, robot, dir) when dir in ["^", "v"] do
    if can_move(grid, robot, dir) do
      move_vert(grid, robot, dir)
    else
      {grid, robot}
    end
  end

  def move_sideways(grid, {robot_i, _robot_j} = robot, dir) do
    vector = vector_for(dir)
    new_robot = add_points(robot, vector)

    grid =
      dir
      |> range_for(robot)
      |> Enum.take_while(fn j -> grid[{robot_i, j}] in ["[", "]"] end)
      |> Enum.map(fn j -> {robot_i, j} end)
      |> Enum.reverse()
      |> Enum.reduce(grid, fn pos, acc ->
        Map.put(acc, add_points(pos, vector), acc[pos])
      end)
      |> Map.put(new_robot, "@")
      |> Map.delete(robot)

    # print(grid)
    {grid, new_robot}
  end

  def move_vert(grid, robot, dir) do
    vector = vector_for(dir)
    new_robot = add_points(robot, vector)

    grid =
      grid
      |> boxes_for(robot, dir)
      |> then(fn boxes ->
        if dir == "^" do
          boxes |> Enum.sort() |> Enum.uniq()
        else
          boxes |> Enum.sort() |> Enum.uniq() |> Enum.reverse()
        end
      end)
      |> Enum.reduce(grid, fn box, acc ->
        acc
        |> Map.put(add_points(box, vector), acc[box])
        |> Map.delete(box)
      end)
      |> Map.put(new_robot, "@")
      |> Map.delete(robot)

    {grid, new_robot}
  end

  def boxes_for(grid, pos, dir, boxes \\ []) do
    vector = vector_for(dir)
    next_pos = add_points(pos, vector)
    {next_i, next_j} = next_pos

    case grid[next_pos] do
      "[" ->
        other_box = {next_i, next_j + 1}

        boxes_for(grid, next_pos, dir, [next_pos | boxes]) ++
          boxes_for(grid, other_box, dir, [other_box])

      "]" ->
        other_box = {next_i, next_j - 1}

        boxes_for(grid, next_pos, dir, [next_pos | boxes]) ++
          boxes_for(grid, other_box, dir, [other_box])

      _ ->
        boxes
    end
  end

  def can_move(grid, robot, "<"), do: can_move_sideways(grid, robot, "<")
  def can_move(grid, robot, ">"), do: can_move_sideways(grid, robot, ">")
  def can_move(grid, {cur_i, cur_j}, "^"), do: can_move_vert(grid, cur_i - 1, cur_j, "^")
  def can_move(grid, {cur_i, cur_j}, "v"), do: can_move_vert(grid, cur_i + 1, cur_j, "v")

  def can_move_sideways(grid, {robot_i, _robot_j} = robot, dir) do
    j = Enum.find(range_for(dir, robot), fn j -> grid[{robot_i, j}] in ["#", nil] end)
    grid[{robot_i, j}] == nil
  end

  def can_move_vert(grid, next_i, next_j, dir) do
    next_val = grid[{next_i, next_j}]

    case next_val do
      nil -> true
      "#" -> false
      "[" -> can_move(grid, {next_i, next_j}, dir) and can_move(grid, {next_i, next_j + 1}, dir)
      "]" -> can_move(grid, {next_i, next_j}, dir) and can_move(grid, {next_i, next_j - 1}, dir)
    end
  end

  def score(grid) do
    grid
    |> Enum.map(fn
      {{i, j}, "O"} -> 100 * i + j
      _ -> 0
    end)
    |> Enum.sum()
  end


  def range_for("<", {_i, j}), do: (j - 1)..0//-1
  def range_for(">", {_i, j}), do: (j + 1)..99
  def range_for("^", {i, _j}), do: (i - 1)..0//-1
  def range_for("v", {i, _j}), do: (i + 1)..99

  def vector_for("<"), do: {0, -1}
  def vector_for(">"), do: {0, 1}
  def vector_for("^"), do: {-1, 0}
  def vector_for("v"), do: {1, 0}

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
      |> Enum.flat_map(fn {{i, j}, val} ->
        case val do
          "@" ->
            [{{i, j * 2}, val}]

          "O" ->
            [
              {{i, j * 2}, "["},
              {{i, j * 2 + 1}, "]"}
            ]

          "#" ->
            [
              {{i, j * 2}, val},
              {{i, j * 2 + 1}, val}
            ]
        end
      end)
      |> Map.new()

    moves = part2 |> String.codepoints() |> Enum.reject(fn c -> c == "\n" end)

    {grid, moves}
  end
end

Main.main() |> IO.puts()

# 9021 - input-small.txt answer
# 1482350 - input-large.txt answer
