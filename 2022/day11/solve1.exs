defmodule Main do

  def go() do
    lines =
      "input-large.txt"
      # "input-small.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    data = parse_lines(lines)
    data = Enum.reduce(1..20, data, fn _, acc -> do_round(acc) end)
    [x, y | _] =
      data.keys
      |> Enum.map(&(data[&1].cnt))
      |> Enum.sort
      |> Enum.reverse
    x * y
  end

  def do_round(data) do
    Enum.reduce(data.keys, data, fn key, acc -> do_monkey(acc[key], acc) end)
  end

  def do_monkey(mon, data) do
    Enum.reduce(mon.items, data, fn item, acc ->
      case mon.op do
        ["*", "old"] ->
          item = (item * item) |> div(3)
          update_items(acc, mon, item)
        ["*", op2] ->
          item = (item * String.to_integer(op2)) |> div(3)
          update_items(acc, mon, item)
        ["+", op2] ->
          item = (item + String.to_integer(op2)) |> div(3)
          update_items(acc, mon, item)
      end
    end)
    |> put_in([mon.key, :items], [])
    |> put_in([mon.key, :cnt], data[mon.key].cnt + length(mon.items))
  end

  def update_items(data, mon, item) do
    mon2_key = mon[rem(item, mon.test) == 0]
    mon2_items = data[mon2_key][:items] ++ [item]
    put_in(data[mon2_key][:items], mon2_items)
  end

  def parse_lines(lines) do
    Enum.reduce(lines, %{keys: []}, fn line, acc ->
      key = List.last(acc[:keys])
      cond do
        Regex.run(~r/^Monkey/, line) ->
          [_, key] = Regex.run(~r/Monkey (.+):/, line)
          mon = %{key: key, cnt: 0}
          Map.merge(acc, %{:keys => acc.keys ++ [key], key => mon})
        Regex.run(~r/Starting items:/, line) ->
          [_, s] = Regex.run(~r/Starting items: (.+)/, line)
          items = String.split(s, ", ") |> Enum.map(&String.to_integer(&1))
          put_in acc[key][:items], items
        Regex.run(~r/Operation:/, line) ->
          [_, s] = Regex.run(~r/Operation: new = old (.+)/, line)
          put_in acc[key][:op], String.split(s)
        Regex.run(~r/Test:/, line) ->
          [_, s] = Regex.run(~r/Test: divisible by (.+)/, line)
          put_in acc[key][:test], String.to_integer(s)
        Regex.run(~r/If true:/, line) ->
          [_, s] = Regex.run(~r/If true: throw to monkey (.+)/, line)
          put_in acc[key][true], s
        Regex.run(~r/If false:/, line) ->
          [_, s] = Regex.run(~r/If false: throw to monkey (.+)/, line)
          put_in acc[key][false], s
        true -> acc
      end
    end)
  end

  def p(o) do
    IO.inspect(o, charlists: :as_lists)
  end

end

IO.inspect(Main.go(), charlists: :as_lists)

# 10605 - input-small.txt answer
# 67830 - input-large.txt answer
