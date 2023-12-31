defmodule Main do
  def go() do
    chunk_fun = fn
      "", acc -> {:cont, acc, []}
      x, acc -> {:cont, [String.to_integer(x) | acc]}
    end

    # "input-small.txt"
    "input-large.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.chunk_while([], chunk_fun, &{:cont, &1, []})
    |> Enum.map(&Enum.sum(&1))
    |> Enum.max()
  end
end

IO.puts(Main.go())

# 24000 - input-small.txt answer
# 72478 - input-large.txt answer

