defmodule Main do
  def main() do
    #{blocks, _max_x, _max_y} = "input-small.txt" |> parse_input()
    {blocks, _max_x, _max_y} = "input-large.txt" |> parse_input()
    settled = lower_until(blocks)

    IO.puts "done lowering"

    #blocks_set = MapSet.new(settled)

    #blocks_set
    settled
    |> Enum.with_index(1)
    |> Enum.filter(fn {block, i} ->
      now = DateTime.utc_now |> DateTime.to_unix
      p [cnt: i, time: now]
      #new_blocks = blocks_set |> MapSet.delete(block) |> MapSet.to_list
      new_blocks = settled |> List.delete(block)
      lower(new_blocks) == new_blocks
    end)
    |> length
  end

  def lower_until(blocks, prev \\ nil, cnt \\ 1)
  def lower_until(blocks, prev, _cnt) when blocks == prev, do: blocks
  def lower_until(blocks, _prev, cnt) do
    now = DateTime.utc_now |> DateTime.to_unix
    p [cnt: cnt, time: now]
    # 170
    lowered = lower(blocks)
    lower_until(lowered, blocks, cnt+1)
  end

  def lower(blocks) do
    lower(blocks, [])
  end

  def lower([], done), do: Enum.reverse(done)

  def lower([block | blocks], done) do
    lowered = lower_block(block)
    if check_block(blocks++done, lowered) do
      lower(blocks, [ lowered | done ])
    else
      lower(blocks, [ block | done ])
    end
  end

  def check_block(blocks, block) do
    block = MapSet.new(block)
    check_floor(block) and Enum.all?(blocks, fn b ->
      (MapSet.new(b) |> MapSet.intersection(block) |> MapSet.size) == 0
    end)
  end

  def lower_block(block) do
    block |> Enum.map(fn {x, y, z} -> {x, y, z - 1} end)
  end

  def check_floor(block) do
    Enum.any?(block, fn {_x, _y, z} -> z > 0 end)
  end

  def parse_input(path) do
    blocks =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        points = Regex.run(~r/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/, line) |> tl
        [x1, y1, z1, x2, y2, z2] = points |> Enum.map(&(String.to_integer(&1)))
        for x <- x1..x2, y <- y1..y2, z <- z1..z2 do
          {x, y, z}
        end
        #|> MapSet.new
        #%{x1: x1, y1: y1, z1: z1, x2: x2, y2: y2, z2: z2}
      end)
    max_x = blocks |> Enum.flat_map(fn block -> block |> Enum.to_list |> Enum.map(&elem(&1, 0)) end) |> Enum.max
    max_y = blocks |> Enum.flat_map(fn block -> block |> Enum.to_list |> Enum.map(&elem(&1, 1)) end) |> Enum.max
    {max_x, max_y}
    {blocks, max_x, max_y}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> IO.inspect()

# elixir solve1.exs  694.53s user 4.28s system 99% cpu 11:40.51 total
# 507 - input-large.txt answer
