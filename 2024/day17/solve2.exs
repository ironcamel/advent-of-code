defmodule Main do
  def main() do
    # {reg, opcodes} = parse_input("input-small.txt")
    {reg, opcodes} = parse_input("input-large.txt")
    # {reg, opcodes} = parse_input("foo.txt")
    dbg()

    Enum.map(0..15, fn i ->
      # Enum.find(1..1_000_000, fn j ->
      #  out = run(%{reg | a: 2 ** (i*3) + j}, opcodes)
      #  elem(out, i) == elem(opcodes, i)
      # end)

      Enum.map(0..7, fn j ->
        [i, run(%{reg | a: 2 ** (i * 3) + j}, opcodes)]
      end)
    end)

    a =
      Enum.reduce(15..0//-1, 8 ** 15, fn i, acc ->
        # dbg i
        acc =
          Enum.find(acc..(8 ** 16)//8 ** i, fn a ->
            out = run(%{reg | a: a}, opcodes)
            elem(out, i) == elem(opcodes, i)
          end)

        # dbg acc: acc, out: run(%{reg | a: acc}, opcodes)
        acc
      end)
      |> dbg

    #a = 107408875647753
    #out = run(%{reg | a: a}, opcodes)
    #foo(reg, opcodes, a)
    foo(reg, opcodes, 8 ** 15)

    #dbg Enum.reject(15..0//-1, fn i -> elem(opcodes, i) == elem(out, i) end)
    #bad = Enum.reject(0..15, fn i -> elem(opcodes, i) == elem(out, i) end)
    #dbg bad

    #Enum.find(a..(8 ** 16)//(8**hd(bad)), fn a ->
    #  out = run(%{reg | a: a}, opcodes)
    #  #elem(out, i) == elem(opcodes, i)
    #  dbg Enum.reject(0..15, fn i -> elem(opcodes, i) == elem(out, i) end)
    #  out == opcodes
    #end)

    # Enum.map(8**16..8**16 + 512, fn a ->
    #  [a, run(%{reg | a: a}, opcodes)]
    # end)

    # run(%{reg | a: 2 ** 5 + 2 ** 7}, opcodes)
  end

  def foo(reg, opcodes, a) do
    out = run(%{reg | a: a}, opcodes)
    #bad = Enum.reject(0..15, fn i -> elem(opcodes, i) == elem(out, i) end)
    bad = Enum.reject(15..0, fn i -> elem(opcodes, i) == elem(out, i) end)
    if out == opcodes do
      a
    else
      dbg bad
      foo(reg, opcodes, a + 8 ** hd(bad))
    end
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

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 107416870455451 - input-large.txt answer
