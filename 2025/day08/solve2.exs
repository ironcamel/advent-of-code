Mix.install([:heap])

defmodule Main do
  def main() do
    boxes = parse_input("input-large.txt")
    num_boxes = length(boxes)

    distances =
      for box1 <- boxes, box2 <- boxes, box1 != box2 do
        {dist(box1, box2), box1, box2}
      end
      |> Enum.into(Heap.min())

    {{x1, _, _}, {x2, _, _}} =
      Enum.reduce_while(1..9_999_999, {distances, []}, fn _i, acc ->
        {distances, circuits} = acc
        {_min, box1, box2} = Heap.root(distances)
        distances = Heap.pop(distances)
        set1 = Enum.find(circuits, MapSet.new(), fn set -> MapSet.member?(set, box1) end)
        set2 = Enum.find(circuits, MapSet.new(), fn set -> MapSet.member?(set, box2) end)
        circuits = Enum.reject(circuits, fn c -> c == set1 or c == set2 end)
        set1 = MapSet.put(set1, box1)
        set2 = MapSet.put(set2, box2)
        new_set = MapSet.union(set1, set2)
        if MapSet.size(new_set) == num_boxes do
          {:halt, {box1, box2}}
        else
          {:cont, {distances, [new_set | circuits]}}
        end
      end)

    x1 * x2
  end

  def dist({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2)
  end

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

# 25272 - input-small.txt answer
# 133296744 - input-large.txt answer
