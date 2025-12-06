defmodule Main do
  def main() do
    "input-large.txt"
    #"input-small.txt"
    |> parse_input()
    |> Enum.map(fn
      ["+" | values] ->
        Enum.reduce(values, fn x, acc -> acc + x end)
      ["*" | values] ->
        Enum.reduce(values, fn x, acc -> acc * x end)
    end)
    |> Enum.sum()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    # |> Enum.with_index()
    |> Enum.map(&String.split/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(fn [op | values] ->
      [op | Enum.map(values, &String.to_integer/1)]
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()
