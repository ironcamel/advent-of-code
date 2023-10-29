defmodule Main do
  require Integer

  @num_shapes 5

  def go() do
    #moves = "input-small.txt" |> parse_input
    moves = "input-large.txt" |> parse_input
    floor = 1..7 |> Enum.to_list |> Map.from_keys(true)
    grid = %{0 => floor}
    data = %{grid: grid, shapes: shapes(), moves: moves, move_cnt: 0, active_rock: nil, rock_cnt: 0, move: nil}
    find_loop(data)
    {data, c0, c1, h0, h1} = find_loop(data)
    cycle_length = c1 - c0
    rocks_in_cycle = cycle_length * @num_shapes
    total_rocks_dropped = c1 * @num_shapes
    remaining = 1_000_000_000_000 - total_rocks_dropped
    cycles_remaining = div(remaining, rocks_in_cycle)
    num_rocks_left = rem(remaining, rocks_in_cycle)
    cycle_height = h1 - h0
    data = place_rocks(data, num_rocks_left)
    height(data.grid) + cycles_remaining * cycle_height
  end

  def place_rocks(data, num) when num <= 0, do: data

  def place_rocks(data, num) do
    Enum.reduce(1..num//1, data, fn _, acc -> tick(acc, :next_shape) end)
  end

  def find_loop(data) do
    round = 0
    move_map = %{0 => 0}
    height_map = %{0 => 0}
    find_loop(data, round, move_map, height_map)
  end

  def find_loop(data, round, move_map, height_map) do
    data = place_rocks(data, @num_shapes)
    round = round + 1
    h = height(data.grid)
    move_idx = get_move_idx(data)
    cycle_start = Map.get(move_map, move_idx)
    if cycle_start && cycle_start > 600 do
      h0 = Map.get(height_map, cycle_start)
      {data, cycle_start, round, h0, h}
    else
      move_map = Map.put(move_map, move_idx, round)
      height_map = Map.put(height_map, round, h)
      find_loop(data, round, move_map, height_map)
    end
  end

  def tick(data, state) do
    %{active_rock: active_rock, grid: grid, rock_cnt: rock_cnt} = data
    case state do
      :next_shape ->
        h = height(grid)
        data = new_rock(data, 3, h+4)
        tick(data, :move)
      :move ->
        data = next_move(data)
        data =
          if will_collide(data, active_rock, data.move) do
            data
          else
            grid = zap_rock(grid, active_rock)
            rock = shift_rock(active_rock, data.move)
            grid = merge_rock(grid, rock)
            %{data | active_rock: rock, grid: grid}
          end
        tick(data, :down)
      :down ->
        if will_collide(data, active_rock, :down) do
          %{data | rock_cnt: rock_cnt+1}
        else
          grid = zap_rock(grid, active_rock)
          rock = lower_rock(active_rock)
          grid = merge_rock(grid, rock)
          data = %{data | active_rock: rock, grid: grid}
          tick(data, :move)
        end
    end
  end

  def lower_rock(rock) do
    (for {i, row} <- rock, do: {i-1, row}) |> Map.new()
  end

  def merge_rock(grid, rock) do
    Enum.reduce(rock, grid, fn {i, row}, acc ->
      row = Map.merge(grid[i] || %{}, row)
      Map.put(acc, i, row)
    end)
  end

  def zap_rock(grid, rock) do
    Enum.reduce(rock, grid, fn {i, row}, acc ->
      inv_row = Map.from_keys(Map.keys(row), false)
      grid_row =
        acc[i]
        |> Map.merge(inv_row)
        |> Enum.filter(fn {_j, val} -> val end)
        |> Map.new()
      if grid_row == %{}, do: Map.delete(acc, i), else: Map.put(acc, i, grid_row)
    end)
  end

  def shift_rock(rock, x) do
    for {i, row} <- rock do
      row = (for {j, val} <- row, do: {j+x, val}) |> Map.new()
      {i, row}
    end
    |> Map.new()
  end

  def will_collide(%{grid: grid}, rock, :down) do
    Enum.find(rock, fn {i, row} ->
      Enum.find(row, fn {j, _val} -> grid[i-1][j] && !rock[i-1][j] end)
    end)
  end

  def will_collide(%{grid: grid}, rock, x) do
    Enum.find(rock, fn {i, row} ->
      Enum.find(row, fn {j, _val} ->
        (grid[i][j+x] && !rock[i][j+x]) || (j+x > 7) || (j+x < 1)
      end)
    end)
  end

  def new_rock(%{grid: grid} = data, x, y) do
    shape = get_shape(data)
    rock =
      for {i, row} <- shape do
        row = (for {j, val} <- row, do: {j+x, val}) |> Map.new()
        {i+y, row}
      end
      |> Map.new()
    grid = merge_rock(grid, rock)
    %{data | grid: grid, active_rock: rock}
  end

  def height(grid) do
    max_row = grid |> Map.keys |> Enum.max
    Enum.find(max_row..0, fn i ->
      Enum.find(grid[i] || %{}, fn {_j, val} -> val end)
    end)
  end

  def get_shape(%{rock_cnt: rock_cnt} = data), do: data.shapes[rem(rock_cnt, @num_shapes)]

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.codepoints
    |> Enum.map(&(if &1 == ">", do: 1, else: -1))
    |> List.to_tuple
  end

  def shapes() do
    t = true
    %{
      0 => %{
        0 => %{0 => t, 1 => t, 2 => t, 3 => t},
      },
      1 => %{
        2 => %{        1 => t        },
        1 => %{0 => t, 1 => t, 2 => t},
        0 => %{        1 => t        },
      },
      2 => %{
        2 => %{                2 => t},
        1 => %{                2 => t},
        0 => %{0 => t, 1 => t, 2 => t},
      },
      3 => %{
        3 => %{0 => t},
        2 => %{0 => t},
        1 => %{0 => t},
        0 => %{0 => t},
      },
      4 => %{
        1 => %{0 => t, 1 => t},
        0 => %{0 => t, 1 => t},
      },
    }
  end

  def next_move(%{move_cnt: move_cnt, moves: moves} = data) do
    move = elem(moves, get_move_idx(data))
    %{data | move_cnt: move_cnt+1, move: move}
  end

  def get_move_idx(%{move_cnt: move_cnt, moves: moves}) do
    rem(move_cnt, tuple_size(moves))
  end
end

IO.puts Main.go()

# 1514285714288 - input-small.txt answer
# 1500874635587 - input-large.txt answer
