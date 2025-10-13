defmodule Main do
  def main() do
    {gates, wires} = parse_input("input-large.txt")

    0..45
    |> Enum.map(fn i -> "z" <> String.pad_leading("#{i}", 2, "0") end)
    |> Enum.reduce(wires, fn wire, acc -> resolve(gates, acc, wire) end)
    |> wires_to_int()
  end

  def wires_to_int(wires) do
    wires
    |> Enum.filter(fn {wire, _} -> String.starts_with?(wire, "z") end)
    |> Enum.sort(:desc)
    |> Enum.map(fn {_, val} -> if val, do: 1, else: 0 end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def resolve(gates, wires, wire) do
    if wires[wire] != nil do
      wires
    else
      {wire1, op, wire2} = gates[wire]
      wires1 = resolve(gates, wires, wire1)
      wires2 = resolve(gates, wires, wire2)
      val = do_op(op, wires1[wire1], wires2[wire2])
      wires1 |> Map.merge(wires2) |> Map.put(wire, val)
    end
  end

  def do_op("AND", a, b), do: a and b
  def do_op("OR", a, b), do: a or b
  def do_op("XOR", a, b), do: a != b

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.split("\n\n", trim: true)

    wires =
      part1
      |> String.split("\n")
      |> Enum.reduce(%{}, fn line, acc ->
        [a, val] = String.split(line, ": ")
        Map.put(acc, a, val == "1")
      end)

    gates =
      part2
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [a, op, b, _, c] = String.split(line)
        {c, {a, op, b}}
      end)
      |> Map.new()

    {gates, wires}
  end
end

Main.main() |> IO.puts()

# 2024 - input-small.txt answer
# 36902370467952 - input-large.txt answer
