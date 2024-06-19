defmodule Main do
  def main() do
    {paper, folds} = parse_input("input-large.txt")
    paper |> fold(hd(folds)) |> map_size
  end

  def fold(paper, {:x, x_val}) do
    half1 = Map.filter(paper, fn {{x, _y}, _val} -> x < x_val end)
    half2 = Map.filter(paper, fn {{x, _y}, _val} -> x > x_val end)

    Enum.reduce(half2, half1, fn {{x, y}, _v}, acc ->
      diff = x - x_val
      Map.put(acc, {x_val - diff, y}, true)
    end)
  end

  def fold(paper, {:y, y_val}) do
    half1 = Map.filter(paper, fn {{_x, y}, _val} -> y < y_val end)
    half2 = Map.filter(paper, fn {{_x, y}, _val} -> y > y_val end)

    Enum.reduce(half2, half1, fn {{x, y}, _v}, acc ->
      diff = y - y_val
      Map.put(acc, {x, y_val - diff}, true)
    end)
  end

  def parse_input(path) do
    [part1, part2] =
      path
      |> File.read!()
      |> String.split("\n\n")

    paper =
      part1
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ",")
        {String.to_integer(x), String.to_integer(y)}
      end)
      |> Enum.map(fn point -> {point, true} end)
      |> Map.new()

    folds =
      part2
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_, c, val] = Regex.run(~r/fold along (.)=(\d+)/, line)
        {String.to_atom(c), String.to_integer(val)}
      end)

    {paper, folds}
  end
end

Main.main() |> IO.puts()

# 17 - input-small.txt answer
# 664 - input-large.txt answer
