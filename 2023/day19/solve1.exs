defmodule Main do
  def main() do
    {toys, workflows} = parse_input("input-large.txt")

    toys
    |> Enum.filter(fn toy -> check_rules(workflows, toy) end)
    |> Enum.flat_map(fn toy -> Map.values(toy) end)
    |> Enum.sum()
  end

  def check_rules(workflows, toy), do: check_rules(workflows, toy, workflows["in"])
  def check_rules(_workflows, _toy, ["A"]), do: true
  def check_rules(_workflows, _toy, ["R"]), do: false
  def check_rules(workflows, toy, [id]), do: check_rules(workflows, toy, workflows[id])

  def check_rules(workflows, toy, [rule | rules]) do
    [eq, dest] = String.split(rule, ":")
    [_, attr, op, num] = Regex.run(~r/(.)(.)(\d+)/, eq)
    num = String.to_integer(num)

    if check_rule(workflows, toy, attr, op, num) do
      case dest do
        "A" -> true
        "R" -> false
        id -> check_rules(workflows, toy, workflows[id])
      end
    else
      check_rules(workflows, toy, rules)
    end
  end

  def check_rule(_workflows, toy, attr, "<", num), do: toy[attr] < num
  def check_rule(_workflows, toy, attr, ">", num), do: toy[attr] > num

  def parse_input(path) do
    [workflows, toys] =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n")

    workflows =
      workflows
      |> String.split("\n")
      |> Enum.map(fn line ->
        [_, id, workflows] = Regex.run(~r/(.+)\{(.+)\}/, line)
        {id, String.split(workflows, ",")}
      end)
      |> Map.new()

    toys =
      toys
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.trim("{")
        |> String.trim("}")
        |> String.split(",")
        |> Enum.map(fn attr ->
          [k, v] = String.split(attr, "=")
          {k, String.to_integer(v)}
        end)
        |> Map.new()
      end)

    {toys, workflows}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 19114 - input-small.txt answer
# 456651 - input-large.txt answer
