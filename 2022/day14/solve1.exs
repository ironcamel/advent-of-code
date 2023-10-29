defmodule Main do

  def go() do
    paths =
      "input-large.txt"
      #"input-small.txt"
      |> parse_input
    draw_paths(paths)
    |> pour()
  end

  def pour(data, cnt \\ 1) do
    case drop(data) do
      {:ok, data} -> pour(data, cnt+1)
      {:done, _} -> cnt - 1
    end
  end

  def draw_data(data) do
    Enum.each(0..9, fn y ->
      Enum.each(494..503, fn x ->
        if(data[x][y], do: "o", else: ".") |> IO.write
      end)
      IO.puts ""
    end)
    data
  end

  def put_x(data, x), do: if data[x], do: data, else: Map.put(data, x, %{})

  def drop(data, {x, y} \\ {500, 0}) do
    data = data |> put_x(x) |> put_x(x-1) |> put_x(x+1)
    y_s = Map.keys(data[x]) |> Enum.filter(fn y2 -> y2 >= y end)
    floor_y = Enum.min(y_s, fn -> 0 end)
    y = floor_y - 1
    cond do
      y < 0 ->
        {:done, data}
      !data[x-1][y+1] ->
        drop(data, {x-1, y+1})
      !data[x+1][y+1] ->
        drop(data, {x+1, y+1})
      true ->
        #p [ "landing at", x, y]
        {:ok, put_in(data[x][y], true) }
    end
  end

  def draw_paths(paths) do
    Enum.reduce(paths, %{}, fn path, acc ->
      draw_path(path, acc) |> elem(0)
    end)
  end

  def draw_path(path, data \\ %{}) do
    Enum.reduce(path, {data, hd(path)}, fn p2, acc ->
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

  def p(o) do
    IO.inspect(o, charlists: :as_lists)
  end

end

IO.inspect(Main.go())

# 24 - input-small.txt answer
# 614 - input-large.txt

