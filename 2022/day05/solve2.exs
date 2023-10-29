defmodule Main do
  def go() do
    lines =
      # "input-small.txt"
      "input-large.txt"
      |> File.read!()
      |> String.split("\n")

    {board, rest} = Enum.split_while(lines, &(!(&1 =~ ~r/1/)))

    stacks =
      Enum.map(board, fn line ->
        Regex.scan(~r/.(.)..?/, line) |> Enum.map(&List.last(&1))
      end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list(&1))
      |> Enum.map(fn x -> Enum.filter(x, &(&1 =~ ~r/\w/)) end)
      |> List.to_tuple()

    stacks = Tuple.insert_at(stacks, 0, [])
    moves = Enum.filter(rest, &(&1 =~ ~r/move/))
    stacks = do_moves(moves, stacks)

    stacks
    |> Tuple.to_list()
    |> tl()
    |> Enum.map(&hd(&1))
    |> Enum.join()
  end

  def do_moves([], stacks), do: stacks

  def do_moves([move | moves], stacks) do
    [[_, cnt, from, to]] = Regex.scan(~r/move (\d+) from (\d+) to (\d+)/, move)
    [cnt, from, to] = [cnt, from, to] |> Enum.map(&String.to_integer(&1))
    stacks = do_cmd(cnt, from, to, stacks)
    do_moves(moves, stacks)
  end

  def do_cmd(cnt, from, to, stacks) do
    {crates, from_stack} = stacks |> elem(from) |> Enum.split(cnt)

    stacks
    |> put_elem(from, from_stack)
    |> put_elem(to, crates ++ elem(stacks, to))
  end
end

IO.puts(Main.go())

# MCD - input-small.txt answer
# LVZPSTTCZ - input-large.txt answer

