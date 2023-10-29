defmodule Main do

  def go() do
    paths =
      "input-large.txt"
      #"input-small.txt"
      |> parse_input
    data = draw_paths(paths)
    max_y = (data |> Map.values |> Enum.map(&Map.keys(&1)) |> List.flatten |> Enum.max) + 2
    pour(data, max_y)
  end

  def pour(data, max_y, cnt \\ 1) do
   case drop(data, max_y) do
     {:ok, data} ->
       p cnt
       #draw_data data
       pour(data, max_y, cnt+1)
     {:done, data} ->
       draw_data data
       cnt
   end
  end

  def put_x(data, x), do: if data[x], do: data, else: Map.put(data, x, %{})

  def drop(data, max_y, {x, y} \\ {500, 0}) do
    data = data |> put_x(x) |> put_x(x-1) |> put_x(x+1)
    y_s = Map.keys(data[x]) |> Enum.filter(fn y2 -> y2 >= y end)
    floor_y = Enum.min(y_s, fn -> max_y end)
    y = floor_y - 1
    p [y: y]
    cond do
      y == max_y - 1 ->
        p [ "landing on inf floor", x, y]
        {:ok, put_in(data[x][y], true) }
      !data[x-1][y+1] ->
        drop(data, max_y, {x-1, y+1})
      !data[x+1][y+1] ->
        drop(data, max_y, {x+1, y+1})
      true ->
        p [ "landing at", x, y]
        data = put_in(data[x][y], true)
        if x == 500 and y == 0 do
          {:done, data }
        else
          {:ok, data }
        end
    end
  end

  def draw_paths(paths) do
    Enum.reduce(paths, %{}, fn path, acc ->
      draw_path(path, acc) |> elem(0)
    end)
  end

  def draw_path(path, data \\ %{}) do
    Enum.reduce(tl(path), {data, hd(path)}, fn p2, acc ->
      {data, p1} = acc
      {draw_line(data, p1, p2), p2}
    end)
  end

  def draw_line(data, p1, p2) do
    [ {x1, y1}, {x2, y2} ] = [ p1, p2 ]
    data = Enum.reduce(x1..x2, data, fn x, acc ->
      if acc[x], do: acc, else: Map.put(acc, x, %{})
    end)
    if x1 == x2 do
      Enum.reduce(y1..y2, data, fn y, acc -> put_in(acc[x1][y], true) end)
    else
      Enum.reduce(x1..x2, data, fn x, acc -> put_in(acc[x][y1], true) end)
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.map(fn points ->
      points
      |> Enum.map(fn point ->
        [x, y] = String.split(point, ",")
        { String.to_integer(x), String.to_integer(y) }
      end)
    end)
  end

  def draw_data(data) do
    #Enum.each(0..110, fn y ->
      #Enum.each(450..550, fn x ->
    Enum.each(0..11, fn y ->
      Enum.each(488..512, fn x ->
        if(data[x][y], do: "o", else: ".") |> IO.write
      end)
      IO.puts ""
    end)
    data
  end

  def p(_o) do
    #IO.inspect(o, charlists: :as_lists)
  end

end

IO.puts(Main.go())

# 93 - input-large.txt answer
# 26170 - input-large.txt answer

