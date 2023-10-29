defmodule Main do

  def go() do
    # "input-small.txt"
    "input-large.txt"
    |> parse_input
    |> Enum.filter(&covers?(&1))
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

  def covers?([a1,a2,b1,b2]), do: (a1 >= b1 and a2 <= b2) or (b1 >= a1 and b2 <= a2)
end

IO.puts(Main.go())

# 2 - input-small.txt answer
# 528 - input-large.txt answer
