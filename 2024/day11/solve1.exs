defmodule Main do
  def main() do
    stones = parse_input("input-large.txt")
    1..25 |> Enum.reduce(stones, fn _i, acc -> Enum.flat_map(acc, &blink/1) end) |> Enum.count()
  end

  def blink("0"), do: ["1"]

  def blink(s) do
    if rem(String.length(s), 2) == 0 do
      {s1, s2} = s |> String.split_at(div(String.length(s), 2))
      [s1 |> String.to_integer() |> to_string(), s2 |> String.to_integer() |> to_string()]
    else
      [(String.to_integer(s) * 2024) |> to_string()]
    end
  end

  def parse_input(path), do: path |> File.read!() |> String.split()
end

Main.main() |> IO.puts()

# 55312 - input-small.txt answer
# 193269 - input-large.txt answer
