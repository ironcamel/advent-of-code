defmodule Main do
  def main() do
    disk = parse_input("input-large.txt")
    size = Enum.count(disk, fn c -> c != "." end)

    disk
    |> fix(Enum.reverse(disk), [], size)
    |> Enum.reject(fn val -> val == "." end)
    |> Enum.with_index()
    |> Enum.map(fn {val, i} -> val * i end)
    |> Enum.sum()
  end

  def fix(_, _, fixed, size) when length(fixed) == size, do: Enum.reverse(fixed)
  def fix(disk, ["." | rev], fixed, size), do: fix(disk, rev, fixed, size)
  def fix(["." | disk], [tail | rev], fixed, size), do: fix(disk, rev, [tail | fixed], size)
  def fix([val | disk], rev, fixed, size), do: fix(disk, rev, [val | fixed], size)

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {[a, b], i} -> List.duplicate(i, a) ++ List.duplicate(".", b)
      {[a], i} -> List.duplicate(i, a)
    end)
  end
end

Main.main() |> IO.puts()

# 1928 - input-small.txt answer
# 6310675819476 - input-large.txt answer
