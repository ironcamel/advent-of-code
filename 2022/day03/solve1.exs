defmodule Main do
  def go() do
    "input-large.txt"
    # "input-small.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&score(&1))
    |> Enum.sum()
  end

  def score(s) do
    len = div(String.length(s), 2)
    a = String.slice(s, 0, len) |> String.to_charlist()
    b = String.slice(s, len, len) |> String.to_charlist()
    c = Enum.take(MapSet.intersection(MapSet.new(a), MapSet.new(b)), 1) |> hd
    if c >= ?a, do: c - ?a + 1, else: c - ?A + 27
  end
end

IO.puts(Main.go())

# 157 - input-small.txt answer
# 7742 - input-large.txt answer
