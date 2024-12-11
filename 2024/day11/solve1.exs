defmodule Main do
  def main() do
    # "input-large.txt"
    #stones = "input-small.txt" |> parse_input()
    stones = "input-large.txt" |> parse_input()

    #1..6
    1..25
    |> Enum.reduce(stones, fn _i, acc ->
      Enum.flat_map(acc, &blink/1)
    end)
    |> Enum.count()
  end

  def blink("0"), do: ["1"]

  def blink(s) do
    if rem(String.length(s), 2) == 0 do
    {s1, s2} = s |> String.split_at(div String.length(s), 2)
    [
      s1 |> String.to_integer() |> to_string(),
      s2 |> String.to_integer() |> to_string(),
    ]
    else
      [(String.to_integer(s) * 2024) |> to_string()]
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split()
    #|> Enum.map(fn n -> String.to_integer(n) end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()
