defmodule Main do
  def main() do
    {reg, opcodes} = parse_input("input-large.txt")
    search(reg, opcodes, 8 ** 15)
  end

  def search(reg, opcodes, a) do
    out = run(%{reg | a: a}, opcodes)
    bad_i = Enum.find(15..0//-1, fn i -> elem(opcodes, i) != elem(out, i) end)
    if bad_i, do: search(reg, opcodes, a + 8 ** bad_i), else: a
  end

  def run(reg, ops, out \\ [], i \\ 0)
  def run(_reg, ops, out, i) when i >= tuple_size(ops), do: List.to_tuple(out)

  def run(reg, ops, out, i) do
    {opcode, operand} = {elem(ops, i), elem(ops, i + 1)}

    case exec(reg, opcode, operand) do
      val when is_list(val) -> run(reg, ops, out ++ val, i + 2)
      val when is_integer(val) -> run(reg, ops, out, val)
      reg -> run(reg, ops, out, i + 2)
    end
  end

  def exec(reg, 0, operand) do
    val = div(reg.a, 2 ** combo(reg, operand))
    %{reg | a: val}
  end

  def exec(reg, 1, operand) do
    val = Bitwise.bxor(reg.b, operand)
    %{reg | b: val}
  end

  def exec(reg, 2, operand) do
    val = reg |> combo(operand) |> rem(8)
    %{reg | b: val}
  end

  def exec(%{a: 0} = reg, 3, _operand), do: reg

  def exec(_reg, 3, operand), do: operand

  def exec(reg, 4, _operand) do
    val = Bitwise.bxor(reg.b, reg.c)
    %{reg | b: val}
  end

  def exec(reg, 5, operand) do
    [reg |> combo(operand) |> rem(8)]
  end

  def exec(reg, 6, operand) do
    val = div(reg.a, 2 ** combo(reg, operand))
    %{reg | b: val}
  end

  def exec(reg, 7, operand) do
    val = div(reg.a, 2 ** combo(reg, operand))
    %{reg | c: val}
  end

  def combo(reg, 4), do: reg.a
  def combo(reg, 5), do: reg.b
  def combo(reg, 6), do: reg.c
  def combo(_reg, operand), do: operand

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.split("\n\n")
    [_, a] = Regex.run(~r/Register A: (.+)/, part1)
    [_, b] = Regex.run(~r/Register B: (.+)/, part1)
    [_, c] = Regex.run(~r/Register C: (.+)/, part1)
    reg = %{a: String.to_integer(a), b: String.to_integer(b), c: String.to_integer(c)}

    opcodes =
      part2
      |> String.split()
      |> List.last()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    {reg, opcodes}
  end
end

Main.main() |> IO.puts()

# 107416870455451 - input-large.txt answer
