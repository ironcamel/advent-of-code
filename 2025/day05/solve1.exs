defmodule Main do
  def main() do
    {ranges, ids} = parse_input("input-large.txt")

    Enum.count(ids, fn id ->
      Enum.any?(ranges, fn range -> id in range end)
    end)
  end

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.trim() |> String.split("\n\n")

    ranges =
      part1
      |> String.split("\n")
      |> Enum.map(fn line ->
        [x, y] = String.split(line, "-")
        String.to_integer(x)..String.to_integer(y)
      end)

    ids = part2 |> String.split("\n") |> Enum.map(&String.to_integer/1)
    {ranges, ids}
  end
end

Main.main() |> IO.puts()

# 3 - input-small.txt answer
# 513 - input-large.txt answer
