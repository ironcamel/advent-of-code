defmodule Main do
  def main() do
    # "input-large.txt"
    #disk = "input-small.txt" |> parse_input()
    disk = "input-large.txt" |> parse_input()
    #num_dots = Enum.count(disk, fn c -> c == "." end)
    final_size = Enum.count(disk, fn c -> c != "." end)
    rev = disk |> Enum.reverse()
    len = length(disk)

    fix(disk, rev, [], final_size)
    |> dbg
    |> Enum.reject(fn val -> val == "." end)
    |> Enum.with_index()
    |> Enum.map(fn {val, i} -> i * val end)
    |> Enum.sum()
  end

  def fix(_disk, _rev, fixed, final_size) when length(fixed) == final_size do
    Enum.reverse(fixed)
  end

  def fix(disk, ["." | rev], fixed, final_size) do
    #dbg()
    fix(disk, rev, fixed, final_size)
  end

  def fix(["." | disk], [tail | rev], fixed, final_size) do
    #dbg()
    fix(disk, rev, [tail | fixed], final_size)
  end

  def fix([val | disk], rev, fixed, final_size) do
    #dbg()
    fix(disk, rev, [val | fixed], final_size)
  end

  def is_fixed(disk, rev, fixed) do
    length(disk) + length(rev) == length(fixed)
  end

  def is_fixed2(disk) do
    s = disk |> Enum.join()
    s =~ ~r/^\d*\.*$/
  end

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

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 1928 - input-small.txt answer
# 6310675819476 - input-large.txt answer
