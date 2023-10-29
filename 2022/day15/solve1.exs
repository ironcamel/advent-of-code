defmodule Main do
  def go() do
    #"input-small.txt" |> parse_input |> calc(10)
    "input-large.txt" |> parse_input |> calc(2_000_000)
  end

  def calc(data, row_y) do
    #data = [ %{b: %{x: 2, y: 10}, radius: 9, x: 8, y: 7} ]
    data = filter(data, row_y)
    p "searching #{length(data)} sensors"
    num_beacons_in_row =
      data
      |> Enum.reduce(MapSet.new(), fn s, acc -> MapSet.put(acc, s.b) end)
      |> Enum.filter(fn b -> b.y == row_y end)
      |> length
    p "found #{num_beacons_in_row} beacons in row"
    Enum.reduce(data, [], fn s, acc ->
      dist_y = abs(s.y - row_y)
      dist_x = s.radius - dist_y
      [ (s.x - dist_x)..(s.x + dist_x) | acc ]
    end)
    |> Enum.reduce(MapSet.new(), fn r, acc ->
      p r
      Enum.reduce(r, acc, fn x, acc2 -> MapSet.put(acc2, x) end)
    end)
    |> MapSet.size
    |> then(fn size -> size - num_beacons_in_row end)
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

  def p(_o) do
    #IO.inspect(o, charlists: :as_lists)
  end
end

IO.puts(Main.go())

# 26 - input-small.txt answer
# 5147333 - input-large.txt answer
