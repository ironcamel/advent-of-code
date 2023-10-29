defmodule Main do
  def go() do
    lines =
      "input-large.txt"
      # "input-small.txt"
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
    {_, stacks} = do_moves(moves, stacks)
    stacks = Tuple.to_list(stacks)
    [_ | stacks] = stacks
    stacks |> Enum.map(&hd(&1)) |> Enum.join()
  end

  def do_moves([], stacks), do: {[], stacks}

  def do_moves([move | moves], stacks) do
    [[_, cnt, from, to]] = Regex.scan(~r/move (\d+) from (\d+) to (\d+)/, move)
    [cnt, from, to] = [cnt, from, to] |> Enum.map(&String.to_integer(&1))
    stacks = do_cmd(cnt, from, to, stacks)
    do_moves(moves, stacks)
  end

  def do_cmd(0, _, _, stacks), do: stacks

  def do_cmd(cnt, from, to, stacks) do
    [crate | from_stack] = elem(stacks, from)
    to_stack = [crate | elem(stacks, to)]

    stacks =
      stacks
      |> put_elem(from, from_stack)
      |> put_elem(to, to_stack)

    do_cmd(cnt - 1, from, to, stacks)
  end
end

IO.puts(Main.go())

# CMZ - input-small.txt answer
# MQTPGLLDN - input-large.txt anser
