defmodule Main do
  @north {0, -1}
  @east {1, 0}
  @south {0, 1}
  @west {-1, 0}
  @unit_circle [@north, @west, @south, @east]

  def main() do
    # "input-large.txt"
    #red_tiles = parse_input("input-small.txt")
    red_tiles = parse_input("input-large.txt")

    pairs = gen_pairs(red_tiles)
    outline = paint(pairs)
    corners = MapSet.new(red_tiles)

    horz_lines =
      pairs
      |> Enum.filter(fn [{_x1, y1}, {_x2, y2}] -> y1 == y2 end)
      |> Enum.map(fn [{x1, y1}, {x2, _y2}] ->
        if x1 < x2 do
          {y1, x1..x2}
        else
          {y1, x2..x1}
        end
      end)

    vert_lines =
      pairs
      |> Enum.filter(fn [{x1, _y1}, {x2, _y2}] -> x1 == x2 end)
      |> Enum.map(fn [{x1, y1}, {_x2, y2}] ->
        if y1 < y2 do
          {x1, y1..y2}
        else
          {x1, y2..y1}
        end
      end)

    {min_x, max_x} = red_tiles |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = red_tiles |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    dbg {min_x, max_x, min_y, max_y}

    _corner_types = Enum.reduce(corners, %{}, fn corner, acc ->
      n = MapSet.member?(outline, add_points(corner, @north))
      s = MapSet.member?(outline, add_points(corner, @south))
      e = MapSet.member?(outline, add_points(corner, @east))
      w = MapSet.member?(outline, add_points(corner, @west))
      type =
        cond do
          n and w -> :se
          n and e -> :sw
          s and w -> :ne
          s and e -> :nw
        end
      Map.put(acc, corner, type)
    end)

    _outline_by_y =
      outline
      |> Enum.sort
      |> Enum.reverse
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        points = acc[y] || []
        Map.put(acc, y, [x | points])
      end)

    # is_inside({0, 2}, corners, outline, corner_types, outline_by_y, min_x, max_x, min_y, max_y)

    for tile1 <- red_tiles, tile2 <- red_tiles, tile1 != tile2 do
      {tile1, tile2}
    end
    |> Enum.filter(fn {{x1, _y1}, {x2, _y2}} -> x1 < x2 end)
    #|> Enum.filter(fn {tile1, tile2} ->
    |> Enum.reject(fn {{_x1, y1}, {_x2, y2}} -> abs(y1 - y2) < 4 end)
    |> Enum.reject(fn {{x1, y1}, {x2, y2}} ->
      #{corner1, corner2} = other_corners(tile1, tile2)
      #is_inside(corner1, corners, outline, corner_types, outline_by_y, min_x, max_x, min_y, max_y) and
        #is_inside(corner2, corners, outline, corner_types, outline_by_y, min_x, max_x, min_y, max_y)

      #midpoint = point_between(tile1, tile2)
      #is_inside(midpoint, corners, outline, corner_types, outline_by_y, min_x, max_x, min_y, max_y) and
      #  not has_corners_inside(corners, tile1, tile2)

      #not has_corners_inside(corners, tile1, tile2)

      x_range = (x1+1)..(x2-1)
      y_range =
        if y1 < y2 do
          (y1+1)..(y2-1)
        else
          (y2+1)..(y1-1)
        end
      Enum.any?(vert_lines, fn {x3, y_range2} ->
        x3 in x_range and not Range.disjoint?(y_range, y_range2)
      end) or
        Enum.any?(horz_lines, fn {y3, x_range2} ->
          y3 in y_range and not Range.disjoint?(x_range, x_range2)
        end)
    end)
    |> Enum.map(fn {tile1, tile2} ->
      #dbg [tile1, tile2, area(tile1, tile2)]
      area(tile1, tile2)
    end)
    |> Enum.max()
    #|> dbg
  end

  def has_corners_inside(corners, {x1, y1}, {x2, y2}) do
    {min_x, max_x} = Enum.min_max([x1, x2])
    {min_y, max_y} = Enum.min_max([y1, y2])
    Enum.any?(corners, fn {x, y} -> x > min_x and x < max_x and y > min_y and y < max_y end)
  end

  # return a point between 2 corners
  def point_between({x1, y1}, {x2, y2}) do
    min_x = Enum.min([x1, x2])
    min_y = Enum.min([y1, y2])
    {min_x + 1, min_y + 1}
    #if x1 < x2 do
    #  if y1 < y2 do
    #    {x1 + 1, y1 + 1}
    #  else
    #    {x1 + 1, y2 + 1}
    #  end
    #else
    #  if y1 < y2 do
    #    {x2 + 1, y1 + 1}
    #  else
    #    {x2 + 1, y2 + 1}
    #  end
    #end
  end

  def is_inside({_x, y} = pos, corners, outline, corner_types, outline_by_y, _min_x, max_x, min_y, max_y) do
    cond do
      MapSet.member?(outline, pos) -> true
      y <= min_y or y >= max_y -> false
      true ->
        count = ray_cast2(nil, pos, corners, outline, corner_types, outline_by_y, max_x, 0)
        rem(count, 2) == 1
    end
  end

  def ray_cast2(_state, {x, _y}, _corners, _outline, _corner_type, _outline_by_y, max_x, count) when x >= max_x + 1, do: count

  def ray_cast2(nil, {x, y}, corners, outline, corner_types, outline_by_y, max_x, count) do
    #next_pos = add_points(pos, @east)
    next_x = Enum.find(outline_by_y[y], max_x + 1, fn x1 -> x1 > x end)
    next_pos = {next_x, y}
    #dbg next_pos
    if MapSet.member?(corners, next_pos) do
      corner_type = corner_types[next_pos]
      ray_cast2(corner_type, next_pos, corners, outline, corner_types, outline_by_y, max_x, count)
    else
      count = if MapSet.member?(outline, next_pos), do: count + 1, else: count
      ray_cast2(nil, next_pos, corners, outline, corner_types, outline_by_y, max_x, count)
    end
  end

  def ray_cast2(:nw, pos, corners, outline, corner_types, outline_by_y, max_x, count) do
    next_pos = add_points(pos, @east)
    if MapSet.member?(corners, next_pos) do
      corner_type = corner_types[next_pos]
      case corner_type do
        :ne -> ray_cast2(nil, next_pos, corners, outline, corner_types, outline_by_y, max_x, count)
        :se -> ray_cast2(nil, next_pos, corners, outline, corner_types, outline_by_y, max_x, count + 1)
      end
    else
      ray_cast2(:nw, next_pos, corners, outline, corner_types, outline_by_y, max_x, count)
    end
  end

  def ray_cast2(:sw, pos, corners, outline, corner_types, outline_by_y, max_x, count) do
    next_pos = add_points(pos, @east)
    if MapSet.member?(corners, next_pos) do
      corner_type = corner_types[next_pos]
      case corner_type do
        :ne -> ray_cast2(nil, next_pos, corners, outline, corner_types, outline_by_y, max_x, count + 1)
        :se -> ray_cast2(nil, next_pos, corners, outline, corner_types, outline_by_y, max_x, count)
      end
    else
      ray_cast2(:sw, next_pos, corners, outline, corner_types, outline_by_y, max_x, count)
    end
  end

  def other_corners({x1, y1}, {x2, y2}) do
    {
      {x1, y2},
      {x2, y1}
    }
  end

  def dfs([], visited), do: visited

  def dfs([{x, y} | _nodes], _visited) when x <= 0 or y <= 0 do
    dbg "outside of shape!!!"
  end

  def dfs([node | nodes], visited) do
    #dbg node
    visited = MapSet.put(visited, node)

    next_nodes =
      @unit_circle
      |> Enum.map(fn dir -> add_points(dir, node) end)
      |> Enum.filter(fn p -> !MapSet.member?(visited, p) end)

    dfs(next_nodes ++ nodes, visited)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def gen_pairs(red_tiles) do
    start_tile = hd(red_tiles)
    red_tiles
    |> Enum.chunk_every(2, 1)
    |> then(fn list ->
      [end_tile] = List.last(list)
      List.replace_at(list, -1, [end_tile, start_tile])
    end)
  end

  def paint(pairs, tiles \\ MapSet.new())
  def paint([], tiles), do: tiles

  def paint([[tile1, tile2] | tail], tiles) do
    tiles = paint_line(tile1, tile2, tiles)
    paint(tail, tiles)
  end

  def paint_line({x1, y1}, {x2, y2}, tiles) when x1 == x2 do
    if y1 < y2 do
      y1..y2
    else
      y2..y1
    end
    |> Enum.map(fn y -> {x1, y} end)
    |> MapSet.new()
    |> MapSet.union(tiles)
  end

  def paint_line({x1, y1}, {x2, y2}, tiles) when y1 == y2 do
    if x1 < x2 do
      x1..x2
    else
      x2..x1
    end
    |> Enum.map(fn x -> {x, y1} end)
    |> MapSet.new()
    |> MapSet.union(tiles)
  end

  def area({x1, y1}, {x2, y2}) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [x, y] = String.split(line, ",")
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 24 - input-small.txt answer
# 1542119040 - input-large.txt answer
