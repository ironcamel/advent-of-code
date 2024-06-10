defmodule Main do
  def main() do
    #"input-small.txt"
    "input-large.txt"
    |> parse_input()
    |> Enum.flat_map(fn line -> String.split(line, " ") end)
    |> Enum.count(fn s -> String.length(s) in [2, 3, 4, 7] end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" | ") |> tl |> hd end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 26 - input-small.txt answer
# 456 - input-large.txt answer
