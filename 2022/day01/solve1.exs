defmodule Main do
  def go() do
    chunk_fun = fn
      "", acc -> {:cont, acc, []}
      x, acc -> {:cont, [String.to_integer(x) | acc]}
    end

    # "input-small.txt"
    "input-large.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.chunk_while([], chunk_fun, &{:cont, &1, []})
    |> Enum.reduce(0, fn bag, max -> Enum.max([Enum.sum(bag), max]) end)
  end
end

IO.puts(Main.go())
# 24000 - small
# 72478 - large

