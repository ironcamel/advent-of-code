defmodule Main do

  def go() do
    "input-large.txt"
    #"input-small.txt"
    |> parse_input
    |> Enum.map(fn [x,y] -> cmp(x,y) end)
    |> Enum.with_index(1)
    |> Enum.filter(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&to_list(&1))
    |> Enum.chunk_every(2)
  end

  def cmp([], []), do: true
  def cmp([], [_|_]), do: true
  def cmp([_|_], []), do: false
  def cmp(x1, x2) when x1 == x2, do: true
  def cmp(x1, x2) when is_integer(x1) and is_list(x2), do: cmp([x1], x2)
  def cmp(x1, x2) when is_list(x1) and is_integer(x2), do: cmp(x1, [x2])
  def cmp(x1, x2) when is_integer(x1) and is_integer(x2), do: x1 < x2
  def cmp([x1|t1], [x2|t2]) do
    {x1, x2} = if is_list(x1) or is_list(x2), do: {wrap_int(x1), wrap_int(x2)}, else: {x1,x2}
    if (x1 == x2), do: cmp(t1, t2), else: cmp(x1, x2)
  end

  def wrap_int(i), do: if is_integer(i), do: [i], else: i

  def to_list(s), do: s |> Code.eval_string |> elem(0)

  def p(o) do
    IO.inspect(o, charlists: :as_lists)
  end

end

IO.inspect(Main.go(), charlists: :as_lists)

# 13 - input-small.txt answer
# 5808 - input-large.txt answer
