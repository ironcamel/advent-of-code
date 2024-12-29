defmodule Main do
  def main() do
    {locks, keys} = parse_input("input-large.txt")

    for lock <- locks, key <- keys do
      lock |> Enum.zip(key) |> Enum.map(fn {l, k} -> l + k end)
    end
    |> Enum.count(fn lock_key -> Enum.all?(lock_key, &(&1 <= 7)) end)
  end

  def parse_input(path) do
    {locks, keys} =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(fn o ->
        o
        |> String.split()
        |> Enum.map(&String.codepoints/1)
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
      end)
      |> Enum.split_with(fn o -> o |> hd() |> hd() == "#" end)

    pin_heights = fn locks ->
      for lock <- locks do
        for pin <- lock do
          Enum.count(pin, &(&1 == "#"))
        end
      end
    end

    {pin_heights.(locks), pin_heights.(keys)}
  end
end

Main.main() |> IO.puts()

# 3 - input-small.txt answer
# 3495 - input-large.txt answer
