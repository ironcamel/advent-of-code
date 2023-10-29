defmodule Main do
  def go() do
    #"input-small.txt" |> parse_input |> scan_rows(20)
    "input-large.txt" |> parse_input |> scan_rows(4_000_000)
  end

  def scan_rows(data, max) do
    {{_, x.._}, y} =
      0..max
      |> Enum.find_value(fn y ->
        case scan_row(data, y, max) do
          {r1, r2} -> {{r1, r2}, y}
          _ -> false
        end
      end)
    (x-1) * 4000000 + y
  end

  def scan_row(data, row_y, max_x) do
    data
    |> filter(row_y)
    |> Enum.reduce([], fn s, acc ->
      dist_y = abs(s.y - row_y)
      dist_x = s.radius - dist_y
      r1 = Enum.max([s.x - dist_x, 0])
      r2 = Enum.min([s.x + dist_x, max_x])
      [ r1..r2 | acc ]
    end)
    |> Enum.sort
    |> Enum.reduce_while(0..0, fn r, acc ->
      if Range.disjoint?(r, acc) do
        {:halt, {acc, r}}
      else
        {:cont, merge_ranges(acc, r)}
      end
    end)
  end

  def merge_ranges(r1_left..r1_right, _r2_left..r2_right) do
    r1_left..(Enum.max([r1_right, r2_right]))
  end

  def filter(data, row_y) do
    data |> Enum.filter(fn s -> s.radius >= abs(row_y - s.y) end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&line_to_xy(&1))
    |> Enum.map(fn [x, y, bx, by] ->
      radius = abs(x - bx) + abs(y - by)
      %{x: x, y: y, b: %{x: bx, y: by}, radius: radius}
    end)
  end

  def line_to_xy(line) do
    Regex.run(~r/Sensor at x=(.+), y=(.+): .* x=(.+), y=(.+)/, line)
    |> tl
    |> Enum.map(&String.to_integer(&1))
  end

  def p(o) do
    IO.inspect(o, charlists: :as_lists)
  end
end

Main.p(Main.go())

# 56000011 - input-small.txt answer
# 13734006908372 - input-large.txt answer
