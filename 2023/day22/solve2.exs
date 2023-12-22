defmodule Main do
  def main() do
    #blocks = "input-small.txt" |> parse_input()
    blocks = "input-large.txt" |> parse_input()
    {settled, _} = lower_until(blocks)

    IO.puts "done lowering"

    ##blocks_set = MapSet.new(settled)

    settled
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {block, i}, acc ->
      now = DateTime.utc_now |> DateTime.to_unix
      p [cnt: i, time: now]
      #new_blocks = blocks_set |> MapSet.delete(block) |> MapSet.to_list
      new_blocks = settled |> List.delete(block)
      #{lowered, not_lowered} = lower(new_blocks)
      {_not_lowered, seen} = lower_until(new_blocks)
      #p [block: block, num_lowered: MapSet.size(seen), seen: seen]
      acc + MapSet.size(seen)
    end)
  end

  def lower_until(lowered, not_lowered \\ [], seen_lowered \\ MapSet.new, cnt \\ 1)
  def lower_until([], not_lowered, seen, _cnt), do: {not_lowered, seen}
  def lower_until(lowered, not_lowered, seen, cnt) do
    now = DateTime.utc_now |> DateTime.to_unix
    p [settling_cnt: cnt, time: now]
    {lowered, not_lowered} = lower(lowered ++ not_lowered)
    seen = lowered |> Enum.map(&elem(&1, 1)) |> MapSet.new |> MapSet.union(seen)
    lower_until(lowered, not_lowered, seen, cnt+1)
  end

  def lower(blocks) do
    lower(blocks, [], [])
  end

  def lower([], lowered, not_lowered), do: {lowered, not_lowered}

  def lower([block | blocks], lowered, not_lowered) do
    candidate = lower_block(block)
    if can_lower([blocks, lowered, not_lowered], candidate) do
      lower(blocks, [candidate | lowered], not_lowered)
    else
      lower(blocks, lowered, [block | not_lowered])
    end
  end

  def can_lower(blocks_list, {block, _id}) do
    block = MapSet.new(block)
    check_floor(block) and Enum.all?(blocks_list, fn blocks ->
      Enum.all?(blocks, fn {b, _id} ->
        (MapSet.new(b) |> MapSet.intersection(block) |> MapSet.size) == 0
      end)
    end)
  end

  def lower_block({block, id}) do
    block = block |> Enum.map(fn {x, y, z} -> {x, y, z - 1} end)
    {block, id}
  end

  def check_floor(block) do
    Enum.any?(block, fn {_x, _y, z} -> z > 0 end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.map(fn {line, id} ->
      points = Regex.run(~r/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/, line) |> tl
      [x1, y1, z1, x2, y2, z2] = points |> Enum.map(&(String.to_integer(&1)))
      for x <- x1..x2, y <- y1..y2, z <- z1..z2 do
        {x, y, z}
      end
      |> then(&({&1, id}))
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> IO.inspect()

# 7 - input-small answer
#
# elixir solve2.exs  5652.70s user 27.94s system 99% cpu 1:35:24.44 total
# 51733 - input-large.txt answer
