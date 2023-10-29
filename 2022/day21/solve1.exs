defmodule Main do
  def go() do
    "input-large.txt"
    # "input-small.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&to_pair(&1))
    |> Enum.into(%{})
    |> calc("root")
  end

  def to_pair(line) do
    parts = line |> String.split([" ", ":"], trim: true)
    [key | parts] = parts

    data =
      case parts do
        [val] -> %{val: String.to_integer(val)}
        [left, op, right] -> %{left: left, op: op, right: right}
      end

    {key, data}
  end

  def calc(graph, node) when is_map(node) do
    case node[:op] do
      "+" -> calc(graph, node.left) + calc(graph, node.right)
      "-" -> calc(graph, node.left) - calc(graph, node.right)
      "*" -> calc(graph, node.left) * calc(graph, node.right)
      "/" -> div(calc(graph, node.left), calc(graph, node.right))
      _ -> node.val
    end
  end

  def calc(graph, key), do: calc(graph, graph[key])
end

IO.puts(Main.go())

# 152 - input-small.txt answer
# 286698846151845 - input-large.txt answer
