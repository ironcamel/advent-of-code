defmodule Main do
  def go() do
    #graph = parse_graph "foo.txt"
    graph = parse_graph "input-large.txt"
    #graph = parse_graph "input-small.txt"

    root = graph["root"]
    {expected_val, other_key} = try do
      {calc(graph, root.left), :right}
    catch
      _ -> {calc(graph, root.right), :left}
    end
    npn = graph |> rpn(root[other_key]) |> rpn_to_npn()
    solve(npn, expected_val)
  end

  #[360, 34, "humn", "-", "/"] -> ["/", 360, ["-", 34, "humn"]]
  def rpn_to_npn(ops, stack \\ [])
  def rpn_to_npn([], stack), do: hd(stack)
  def rpn_to_npn([op|tail], stack) when op in ["+", "-", "*", "/"] do
    [y|stack] = stack
    [x|stack] = stack
    stack = [[op, x, y] | stack]
    rpn_to_npn(tail, stack)
  end
  def rpn_to_npn([item|tail], stack), do: rpn_to_npn(tail, [item|stack])

  def solve("humn", ans), do: ans
  def solve(cmd, ans) do
    [op, left, right] = [Enum.at(cmd, 0), Enum.at(cmd, 1), Enum.at(cmd, 2)]
    [val, cmd] = if is_integer(left), do: [left, right], else: [right, left]
    ans = case op do
      "/" -> if is_integer(left), do: val / ans, else: ans * val
      "-" -> if is_integer(left), do: val - ans, else: ans + val
      "+" -> ans - val
      "*" -> ans / val
    end
    solve(cmd, ans)
  end

  def rpn(graph, key), do: rpn(graph, [key], [])
  def rpn(_, [], stack), do: Enum.reverse(stack)
  def rpn(graph, [item|tail], stack) when item in ["+", "-", "*", "/", "humn"] do
    p stack
    rpn(graph, tail, update_stack(stack, item))
  end
  def rpn(graph, [val|tail], stack) when is_integer(val) do
    p stack
    rpn(graph, tail, update_stack(stack, val))
  end
  def rpn(graph, [key|tail], stack) do
    p stack
    node = graph[key]
    if node[:op] do
      rpn(graph, List.flatten([node.left, node.right, node.op], tail), stack)
    else
      rpn(graph, tail, update_stack(stack, node.val))
    end
  end

  def update_stack(stack, op) when op in ["+", "-", "*", "/"] do
    p op
    [a|new_stack] = stack
    [b|new_stack] = new_stack
    if is_integer(a) and is_integer(b) do
      case op do
        "+" -> [b+a | new_stack]
        "-" -> [b-a | new_stack]
        "*" -> [b*a | new_stack]
        "/" -> [div(b,a) | new_stack]
      end
    else
      [op | stack]
    end
  end
  def update_stack(stack, val), do: [val | stack]

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

  def combine(list1, list2, result \\ [])
  def combine([], [], result), do: result
  def combine([], [item], result), do: combine([], [], [item|result])
  def combine([item1|tail1], list2, result) do
    if is_op(item1) and is_op(Enum.at result, 0) do
      result = List.flatten [item1, hd(list2), result]
      combine(tail1, tl(list2), result)
    else
      combine(tail1, list2, [item1|result])
    end
  end

  def is_op(x), do: x in [ "+", "-", "*", "/"]

  def calc(_, "humn"), do: throw("found humn")

  def calc(graph, node) when is_map(node) do
    case node[:op] do
      "+" -> calc(graph, node.left) + calc(graph, node.right)
      "-" -> calc(graph, node.left) - calc(graph, node.right)
      "*" -> calc(graph, node.left) * calc(graph, node.right)
      "/" -> div(calc(graph, node.left), calc(graph, node.right))
      _ -> node.val
    end
  end

  def calc(graph, key) do
    calc(graph, graph[key])
  end

  def parse_graph(path) do
    path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&to_pair(&1))
      |> Enum.into(%{})
  end

  def p(o) do
    #IO.inspect(o)
  end
end

IO.inspect(Main.go())


# 301 - input-small.txt answer
# 3759566892641 - input-large.txt answer
