defmodule Main do
  def main() do
    #{gates, wires} = parse_input("input-small.txt")
    {gates, wires} = parse_input("input-large.txt")

    gates
    |> resolve(wires)
    |> Enum.filter(fn {wire, _} -> String.starts_with?(wire, "z") end)
    |> Enum.sort(:desc)
    |> Enum.map(fn {_, val} -> if val, do: 1, else: 0 end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def resolve(gates, wires) do
    resolve(gates, wires, gates)
  end

  def resolve([], wires, gates) do
    if wires |> Map.values |> Enum.any?(&(&1 == nil)) do
      resolve(gates, wires, gates)
    else
      wires
    end
  end

  def resolve([gate | tail], wires, gates) do
    {wire, {a, op, b}} = gate
    wires = Map.put(wires, wire, do_op(op, wires[a], wires[b]))
    resolve(tail, wires, gates)
  end

  def do_op(_op, a, b) when is_nil(a) or is_nil(b), do: nil
  def do_op("AND", a, b), do: a and b
  def do_op("OR", a, b), do: a or b
  def do_op("XOR", a, b), do: a != b

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.split("\n\n", trim: true)

    gates =
      part2
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [a, op, b, _, c] = String.split(line)
        {c, {a, op, b}}
      end)

    wires =
      gates
      |> Enum.flat_map(fn {c, {a, _op, b}} ->
        [{a, nil}, {b, nil}, {c, nil}]
      end)
      |> Map.new()

    wires =
      part1
      |> String.split("\n")
      |> Enum.reduce(wires, fn line, wires ->
        [a, val] = String.split(line, ": ")
        val = if val == "1", do: true, else: false
        Map.put(wires, a, val)
      end)

    {gates, wires}
  end
end

Main.main() |> IO.puts()

# 2024 - input-small.txt answer
# 36902370467952 - input-large.txt answer
