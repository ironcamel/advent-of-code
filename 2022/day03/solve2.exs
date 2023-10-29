defmodule Main do
  def go() do
    # "input-small.txt"
    "input-large.txt"
    |> File.read!()
    |> String.split()
    |> Enum.chunk_every(3)
    |> Enum.map(fn [r1, r2, r3] ->
      r1 = r1 |> String.to_charlist |> MapSet.new
      r2 = r2 |> String.to_charlist |> MapSet.new
      r3 = r3 |> String.to_charlist |> MapSet.new
      c = MapSet.intersection(r1, r2) |> MapSet.intersection(r3) |> Enum.take(1) |> hd
      if c >= ?a, do: c - ?a + 1, else: c - ?A + 27
    end)
    |> Enum.sum()
  end
end

IO.puts(Main.go())

# 70 - input-small.txt answer
# 2276 - input-large.txt answer
