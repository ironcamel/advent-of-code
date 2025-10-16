defmodule Main do
  import Bitwise
  def main() do
    {gates, wires} = parse_input("input-large.txt")

    gates =
      gates
      |> swap("mkk", "z10")
      |> swap("qbw", "z14")
      |> swap("cvp", "wjb")
      |> swap("wcb", "z34")

    #print(gates, "z00")
    #print(gates, "z01")
    #print(gates, "z02")
    #print(gates, "z03")
    #print(gates, "z04")
    #print(gates, "z09")
    #print(gates, "z10")
    #print(gates, "z11")
    #print(gates, "z12")
    #print(gates, "z13")
    #print(gates, "z14")
    #print(gates, "z15")
    #print(gates, "z24")
    #print(gates, "z25")
    #print(gates, "z26")
    #print(gates, "z32")
    #print(gates, "z33")
    #print(gates, "z34")
    #print(gates, "z35")
    find_bad_bits(gates, wires)

    ["mkk", "z10", "qbw", "z14", "cvp", "wjb", "wcb", "z34"]
    |> Enum.sort()
    |> Enum.join(",")
  end

  def swap(gates, gate1, gate2) do
    Map.merge(gates, %{gate1 => gates[gate2], gate2 => gates[gate1]})
  end

  def find_bad_bits(gates, wires) do
    for i <- 0..44 do
      for j <- 0..44 do
        x = 1 <<< i
        y = 1 <<< j
        ans = resolve(gates, init_wires(wires, x, y)) |> wires_to_int()
        if ans != x + y do
          IO.puts("i: #{i}, j: #{j}")
        end
      end
    end
  end

  def init_wires(wires, x, y) when is_integer(y) do
    wires |> init_wires(x, "x") |> init_wires(y, "y")
  end

  def init_wires(wires, num, prefix) when prefix in ["x", "y"] do
    num
    |> Integer.to_string(2)
    |> String.pad_leading(45, "0")
    |> String.codepoints()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(wires, fn {bit, i}, acc ->
      key = prefix <> String.pad_leading("#{i}", 2, "0")
      Map.put(acc, key, bit == "1")
    end)
  end

  def wires_to_int(wires) do
    wires
    |> Enum.filter(fn {wire, _} -> String.starts_with?(wire, "z") end)
    |> Enum.sort(:desc)
    |> Enum.map(fn {_, val} -> if val, do: 1, else: 0 end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def resolve(gates, wires) do
    0..45
    |> Enum.map(fn i -> "z" <> String.pad_leading("#{i}", 2, "0") end)
    |> Enum.reduce(wires, fn wire, acc -> resolve(gates, acc, wire) end)
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

  def print(gates, wires, visited \\ MapSet.new())
  def print(_gates_map, [], _visited), do: :noop

  def print(gates, wire, visited) when is_binary(wire) do
    print(gates, [{wire, 0}], visited)
  end

  def print(gates, [{wire, depth} | wires], visited) do
    visited = MapSet.put(visited, wire)
    gate = Map.get(gates, wire)
    if gate && depth <= 3 do
      {a, op, b} = gate
      indent = List.duplicate("  ", depth)
      IO.puts("#{indent}#{wire} = #{a} #{op} #{b}")
      print(gates, [{a, depth+1}, {b, depth+1}] ++ wires, visited)
    else
      print(gates, wires, visited)
    end
  end

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

# cvp,mkk,qbw,wcb,wjb,z10,z14,z34 - input-large.txt answer
