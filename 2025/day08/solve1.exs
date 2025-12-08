Mix.install([:heap])

defmodule Main do
  def main() do
    #boxes = parse_input("input-small.txt")
    boxes = parse_input("input-large.txt")

    distances =
      for box1 <- boxes, box2 <- boxes, box1 != box2 do
        Enum.sort([box1, box2])
      end
      |> Enum.sort()
      |> Enum.dedup()
      |> Enum.map(fn [box1, box2] ->
        {dist(box1, box2), box1, box2}
      end)
      |> Enum.into(Heap.min())

    {_, circuits} =
      Enum.reduce(1..1000, {distances, []}, fn _i, acc ->
        {distances, circuits} = acc
        {_min, box1, box2} = Heap.root(distances)
        distances = Heap.pop(distances)
        set1 = Enum.find(circuits, MapSet.new(), fn set -> MapSet.member?(set, box1) end)
        set2 = Enum.find(circuits, MapSet.new(), fn set -> MapSet.member?(set, box2) end)
        circuits = Enum.reject(circuits, fn c -> c == set1 or c == set2 end)
        set1 = MapSet.put(set1, box1)
        set2 = MapSet.put(set2, box2)
        new_set = MapSet.union(set1, set2)
        {distances, [new_set | circuits]}
      end)

    score(circuits)
  end

  def score(circuits) do
    circuits
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def dist({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2)
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 40 - input-small.txt answer
# 57564 - input-large.txt answer
