defmodule Main do
  @offset 10000000000000

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn rule -> cramer(rule) end)
    |> Enum.filter(fn {x, y} -> is_int(x) and is_int(y) end)
    |> Enum.map(fn {a, b} -> 3 * a + b end)
    |> Enum.sum()
  end

  def cramer(%{a: a, b: b, c: c}) do
    d = det(
      [a.x, b.x],
      [a.y, b.y]
    )
    dx = det(
      [c.x, b.x],
      [c.y, b.y]
    )
    dy = det(
      [a.x, c.x],
      [a.y, c.y]
    )
    {dx / d, dy / d}
  end

  def det([i1, j1], [i2, j2]), do: i1 * j2 - i2 * j1

  def is_int(n), do: n == trunc(n)

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
        c: %{x: String.to_integer(x) + @offset, y: String.to_integer(y) + @offset}
      }
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 875318608908 - input-small.txt answer
# 107487112929999 - input-large.txt answer
