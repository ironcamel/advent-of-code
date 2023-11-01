defmodule Main do
  @checks {
    [{-1, -1}, {-1, 0}, {-1, 1}],
    [{1, -1}, {1, 0}, {1, 1}],
    [{-1, -1}, {0, -1}, {1, -1}],
    [{-1, 1}, {0, 1}, {1, 1}]
  }

  def go() do
    # elves = "input-small.txt" |> parse_input()
    elves = "input-large.txt" |> parse_input()

    Enum.reduce_while(1..10_000, elves, fn round, acc ->
      acc2 =
        acc
        |> proposals(round)
        |> resolve()
      if MapSet.equal?(acc, acc2) do
        {:halt, round}
      else
        {:cont, acc2}
      end
    end)
  end

  def proposals(elves, round) do
    elves
    |> Enum.map(fn {i, j} -> check(elves, i, j, round) end)
  end

  def resolve(proposals) do
    dups =
      Enum.reduce(proposals, %{}, fn {_src, dest}, acc ->
        Map.update(acc, dest, 1, &(&1 + 1))
      end)
      |> Enum.filter(fn {_k, v} -> v >= 2 end)
      |> Enum.map(fn {k, _v} -> k end)
      |> MapSet.new()

    proposals
    |> Enum.map(fn {src, dest} ->
      if MapSet.member?(dups, dest), do: src, else: dest
    end)
    |> MapSet.new()
  end

  def check(elves, i, j, round) do
    @checks
    |> Tuple.to_list()
    |> Enum.all?(fn pairs ->
      Enum.all?(pairs, fn {i2, j2} -> !MapSet.member?(elves, {i + i2, j + j2}) end)
    end)
    |> then(fn stay ->
      if stay do
        {{i, j}, {i, j}}
      else
        check2(elves, i, j, round)
      end
    end)
  end

  def check2(elves, i, j, round) do
    0..3
    |> Enum.map(fn n -> elem(@checks, rem(n + round - 1, 4)) end)
    |> Enum.find(fn pairs ->
      Enum.all?(pairs, fn {i2, j2} -> !MapSet.member?(elves, {i + i2, j + j2}) end)
    end)
    |> then(fn
      nil -> {{i, j}, {i, j}}
      [_, {i2, j2}, _] -> {{i, j}, {i + i2, j + j2}}
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.reduce(MapSet.new(), fn {line, i}, acc ->
      line
      |> String.codepoints()
      |> Enum.with_index(1)
      |> Enum.map(fn {c, j} -> {i, j, c} end)
      |> put_elves(acc)
    end)
  end

  def put_elves(tiles, elves) do
    Enum.reduce(tiles, elves, fn {i, j, c}, acc -> put_elf(acc, i, j, c) end)
  end

  def put_elf(elves, _i, _j, "."), do: elves
  def put_elf(elves, i, j, "#"), do: MapSet.put(elves, {i, j})

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.p(Main.go())

# 20 - input-small.txt answer
# 1079 - input-large.txt answer
