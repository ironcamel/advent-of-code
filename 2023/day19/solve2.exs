defmodule Main do
  def main() do
    parse_input("input-large.txt")
    |> dfs()
    |> Enum.map(&List.flatten(&1))
    |> Enum.map(fn rules -> Enum.map(rules, &to_range(&1)) end)
    |> Enum.map(fn rules -> combine(rules) end)
    |> Enum.map(fn rules -> Map.new(rules) end)
    |> Enum.map(fn rule_map -> count_combos(rule_map) end)
    |> Enum.sum()
  end

  def count_combos(rule_map) do
    rule_map
    |> Map.values()
    |> Enum.map(&Range.size(&1))
    |> Enum.product()
  end

  def combine(rules) do
    ["a", "m", "s", "x"]
    |> Enum.reduce([], fn c, acc ->
      rules
      |> Enum.filter(fn {c2, _} -> c2 == c end)
      |> Enum.reduce({c, 1..4000}, fn {_, r3..r4}, {_, r1..r2} ->
        r1 = if r3 > r1, do: r3, else: r1
        r2 = if r4 < r2, do: r4, else: r2
        {c, r1..r2}
      end)
      |> then(fn rule -> [rule | acc] end)
    end)
  end

  def to_range({c, op, val}) do
    case op do
      "<" -> {c, 1..(val - 1)}
      "<=" -> {c, 1..val}
      ">" -> {c, (val + 1)..4000}
      ">=" -> {c, val..4000}
    end
  end

  def dfs(workflows, node \\ "in", visited \\ MapSet.new(), path \\ [])
  def dfs(_workflows, "R", _visited, _path), do: []
  def dfs(_workflows, "A", _visited, path), do: [path]

  def dfs(workflows, node, visited, path) do
    visited = MapSet.put(visited, node)

    workflows[node]
    |> Enum.reject(fn {n, _} -> MapSet.member?(visited, n) end)
    |> Enum.flat_map(fn {child, tests} ->
      dfs(workflows, child, visited, [tests | path])
    end)
  end

  def invert({c, "<", val}), do: {c, ">=", val}
  def invert({c, ">", val}), do: {c, "<=", val}
  def invert({c, ">=", val}), do: {c, "<", val}
  def invert({c, "<=", val}), do: {c, ">", val}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(fn line -> line =~ ~r/^\w/ end)
    |> Enum.map(fn line ->
      [_, id, rules] = Regex.run(~r/(.+)\{(.+)\}/, line)
      {id, parse_rules(rules)}
    end)
    |> Map.new()
  end

  def parse_rules(rules) do
    rules =
      rules
      |> String.split(",")
      |> Enum.map(fn s ->
        if s =~ ~r/<|>/ do
          [_, l, op, r, node] = Regex.run(~r/(.)(.)(\d+):(.+)/, s)
          test = {l, op, String.to_integer(r)}
          {node, [test]}
        else
          {s, []}
        end
      end)

    [rule1 | rules] = rules

    Enum.reduce(rules, [rule1], fn {node, tests}, acc ->
      prev_tests = acc |> List.last() |> elem(1)
      inv = prev_tests |> List.last() |> invert
      prev_tests = prev_tests |> List.delete_at(-1) |> Enum.concat([inv])
      tests = prev_tests ++ tests
      acc ++ [{node, tests}]
    end)
  end
end

Main.main() |> IO.puts()

# 167409079868000 - input-small.txt answer
# 131899818301477 - input-large.txt answer
