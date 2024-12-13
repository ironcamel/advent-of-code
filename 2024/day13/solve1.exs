defmodule Main do
  def main() do
    # "input-large.txt"
    #rules = parse_input("input-small.txt")
    rules = parse_input("input-large.txt")
    #rules = parse_input("foo.txt")

    rules
    |> Enum.map(fn rule ->
      rule
      |> gen_candidates()
      |> Enum.map(fn {a, b} -> 3 * a + b end)
      |> then(fn vals -> if length(vals) > 0, do: vals, else: [0] end)
      |> Enum.min()
    end)
    |> Enum.sum()
  end

  def gen_candidates(%{a: a, b: b, c: c}) do

    x_canditates =
      0..div(c.x, a.x)
      |> Enum.map(fn x1 ->
        x2 = (c.x - x1 * a.x) / b.x
        {x1, x2}
      end)
      |> Enum.filter(fn {_x1, x2} -> x2 == trunc(x2) end)
      |> Enum.map(fn {x1, x2} -> {x1, trunc(x2)} end)
      |> MapSet.new()

    y_canditates =
      0..div(c.y, a.y)
      |> Enum.map(fn y1 ->
        y2 = (c.y - y1 * a.y) / b.y
        {y1, y2}
      end)
      |> Enum.filter(fn {_y1, y2} -> y2 == trunc(y2) end)
      |> Enum.map(fn {y1, y2} -> {y1, trunc(y2)} end)
      |> MapSet.new()

    MapSet.intersection(x_canditates, y_canditates)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn s ->
      [line1, line2, line3] = String.split(s, "\n")
      [_, x1, y1] = Regex.run(~r/Button A: X\+(.+), Y\+(.+)/, line1)
      [_, x2, y2] = Regex.run(~r/Button B: X\+(.+), Y\+(.+)/, line2)
      [_, x, y] = Regex.run(~r/Prize: X=(.+), Y=(.+)/, line3)

      %{
        a: %{x: String.to_integer(x1), y: String.to_integer(y1)},
        b: %{x: String.to_integer(x2), y: String.to_integer(y2)},
        c: %{x: String.to_integer(x), y: String.to_integer(y)}
      }
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 480 - input-small.txt answer
# 25629 - input-large.txt answer
