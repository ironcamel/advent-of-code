defmodule Main do
  def go() do
    line = "input-large.txt" |> File.read!()
    check(line, 14)
  end

  def check(s, len, i \\ 0) do
    s2 = String.slice(s, 0, len)
    uniq_cnt = s2 |> String.to_charlist() |> MapSet.new() |> MapSet.size()

    if uniq_cnt == len do
      i + len
    else
      check(String.split_at(s, 1) |> elem(1), len, i + 1)
    end
  end
end

IO.puts(Main.go())

# 19 - input-small answer
# 3256 - input-large.txt answer
