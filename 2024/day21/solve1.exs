defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn code ->
      n = code |> Enum.filter(fn c -> c =~ ~r/\d/ end) |> Enum.join() |> String.to_integer()

      code
      |> enter_code()
      |> Enum.map(fn code -> enter_code(code) end)
      |> List.flatten()
      |> Enum.map(fn code -> enter_code(code) end)
      |> List.flatten()
      |> Enum.map(&tuple_size/1)
      |> Enum.min()
      |> then(fn min -> min * n end)
    end)
    |> Enum.sum()
  end

  def enter_code(code, path \\ [], cur \\ {3, 2})
  def enter_code([], path, _cur), do: List.to_tuple(path)

  def enter_code(code, path, cur) when is_tuple(code) do
    enter_code(Tuple.to_list(code), path, cur)
  end

  def enter_code([c | code], path, {i0, j0} = cur) do
    {i1, j1} = new_pos = pos_for(c)
    vert_dist = i1 - i0
    horz_dist = j1 - j0
    vert_c = if vert_dist > 0, do: "v", else: "^"
    horz_c = if horz_dist > 0, do: ">", else: "<"

    gen_buttons(abs(vert_dist), vert_c, abs(horz_dist), horz_c)
    |> Enum.reject(fn buttons ->
      buttons
      |> Enum.reduce([cur], fn arrow, acc ->
        new_pos = arrow |> arrow_to_dir() |> add_points(hd(acc))
        [new_pos | acc]
      end)
      |> Enum.any?(fn p -> p == {3, 0} end)
    end)
    |> Enum.map(fn buttons ->
      enter_code(code, path ++ buttons ++ ["A"], new_pos)
    end)
    |> List.flatten()
  end

  def arrow_to_dir(arrow) do
    case arrow do
      "^" -> @north
      ">" -> @east
      "v" -> @south
      "<" -> @west
    end
  end

  def gen_buttons(n1, c1, n2, c2) do
    [
      List.duplicate(c1, n1) ++ List.duplicate(c2, n2),
      List.duplicate(c2, n2) ++ List.duplicate(c1, n1)
    ]
    |> Enum.uniq()
  end

  def pos_for(b) do
    case b do
      "7" -> {0, 0}
      "8" -> {0, 1}
      "9" -> {0, 2}
      "4" -> {1, 0}
      "5" -> {1, 1}
      "6" -> {1, 2}
      "1" -> {2, 0}
      "2" -> {2, 1}
      "3" -> {2, 2}
      "0" -> {3, 1}
      "A" -> {3, 2}
      "^" -> {3, 1}
      "<" -> {4, 0}
      "v" -> {4, 1}
      ">" -> {4, 2}
    end
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> IO.puts()

# 126384 - input-small.txt answer
# 137870 - input-large.txt answer
