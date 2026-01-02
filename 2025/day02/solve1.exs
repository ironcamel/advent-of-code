defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.flat_map(fn {n1, n2} -> Enum.filter(n1..n2, &matches/1) end)
    |> Enum.sum()
  end

  def matches(n) do
    s = Integer.to_string(n)
    len = String.length(s)
    {s1, s2} = String.split_at(s, div(len, 2))
    s1 == s2
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn s ->
      [s1, s2] = String.split(s, "-")
      {String.to_integer(s1), String.to_integer(s2)}
    end)
  end
end

Main.main() |> IO.puts()

# 1227775554 - input-small.txt answer
# 18700015741 - input-large.txt answer
