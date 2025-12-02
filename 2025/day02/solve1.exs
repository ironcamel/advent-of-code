defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.flat_map(fn {n1, n2} -> search(n1, n2) end)
    |> Enum.sum()
  end

  def search(n1, n2, list \\ [])
  def search(n1, n2, list) when n1 > n2, do: list

  def search(n1, n2, list) do
    next = next_candidate(n1)

    if next <= n2 do
      search(next + 1, n2, [next | list])
    else
      list
    end
  end

  def next_candidate(n) do
    s = Integer.to_string(n)
    len = String.length(s)

    cond do
      is_candidate(n) ->
        n

      rem(len, 2) == 1 ->
        n = 10 ** len
        {s, _} = n |> Integer.to_string() |> String.split_at(div(len + 1, 2))
        String.to_integer(s <> s)

      rem(len, 2) == 0 ->
        {s1, s2} = String.split_at(s, div(len, 2))
        n1 = String.to_integer(s1)
        n2 = String.to_integer(s2)

        if n1 < n2 do
          s1 = Integer.to_string(n1 + 1)
          String.to_integer(s1 <> s1)
        else
          String.to_integer(s1 <> s1)
        end
    end
  end

  def is_candidate(n) do
    s = Integer.to_string(n)
    len = String.length(s)

    if rem(len, 2) == 1 do
      false
    else
      {s1, _} = String.split_at(s, div(len, 2))
      s == s1 <> s1
    end
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
