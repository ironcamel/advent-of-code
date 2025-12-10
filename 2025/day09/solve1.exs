defmodule Main do
  def main() do
    # "input-large.txt"
    #tiles = "input-small.txt" |> parse_input()
    tiles = "input-large.txt" |> parse_input()

    for tile1 <- tiles, tile2 <- tiles, tile1 != tile2 do
      #{tile1, tile2}
      area(tile1, tile2)
    end
    |> Enum.max
  end

  def area({x1, y1}, {x2, y2}) do
    abs(x1 - x2 + 1) * abs(y1 - y2 + 1)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

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

# 50 - input-small.txt answer
# 4777824480 - input-large.txt answer
