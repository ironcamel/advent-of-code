defmodule Main do

  def go() do
    # "input-small.txt"
    "input-large.txt"
    |> parse_input
    |> Enum.filter(&overlaps(&1))
    |> Enum.count()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Regex.split(~r/\W/, &1))
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer(&1)) end)
  end

  def overlaps([a1,a2,b1,b2]), do: a1 <= b2 and a2 >= b1
end

IO.puts(Main.go())

# 4 - input-small.txt answer
# 881 - input-large.txt answer
