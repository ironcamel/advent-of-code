defmodule Main do
  def main() do
    "input-large.txt" |> parse_input() |> async() |> List.flatten() |> Enum.sum()
  end

  def async(items) do
    items
    |> Task.async_stream(&solve/1, max_concurrency: 200, ordered: false)
    |> Enum.map(fn {:ok, val} -> val end)
  end

  def solve({n1, n2}), do: Enum.filter(n1..n2, &matches/1)

  def matches(n) do
    s = Integer.to_string(n)
    len = String.length(s)

    Enum.any?(1..div(len, 2)//1, fn i ->
      s1 = String.slice(s, 0, i)
      List.duplicate(s1, div(len, i)) |> Enum.join() == s
    end)
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

# 4174379265 - input-small.txt answer
# 20077272987 - input-large.txt answer
