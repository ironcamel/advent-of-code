defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn code ->
      n = code |> Enum.filter(&(&1 =~ ~r/\d/)) |> Enum.join() |> String.to_integer()

      code
      |> enter_code()
      |> Enum.flat_map(fn code -> enter_code(code) end)
      |> Enum.flat_map(fn code -> enter_code(code) end)
      |> Enum.map(&length/1)
      |> Enum.min()
      |> then(fn min -> min * n end)
    end)
    |> Enum.sum()
  end

  def enter_code(code, paths \\ [[]], cur \\ pos_for("A"))
  def enter_code([], paths, _cur), do: paths

  def enter_code([c | code], paths, {i0, j0} = cur) do
    {i1, j1} = new_pos = pos_for(c)
    vert_dist = i1 - i0
    horz_dist = j1 - j0
    vert_c = if vert_dist > 0, do: "v", else: "^"
    horz_c = if horz_dist > 0, do: ">", else: "<"

    paths =
      gen_buttons(abs(vert_dist), vert_c, abs(horz_dist), horz_c)
      |> Enum.reject(fn buttons ->
        buttons
        |> Enum.reduce([cur], fn arrow, acc ->
          new_pos = arrow |> arrow_to_dir() |> add_points(hd(acc))
          [new_pos | acc]
        end)
        |> Enum.any?(fn p -> p == pos_for(" ") end)
      end)
      |> Enum.flat_map(fn buttons ->
        Enum.map(paths, fn path -> path ++ buttons ++ ["A"] end)
      end)

    enter_code(code, paths, new_pos)
  end

  def arrow_to_dir("^"), do: @north
  def arrow_to_dir(">"), do: @east
  def arrow_to_dir("v"), do: @south
  def arrow_to_dir("<"), do: @west

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
      " " -> {3, 0}
    end
  end

  def add_points({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)
  end
end

Main.main() |> IO.puts()

# 126384 - input-small.txt answer
# 137870 - input-large.txt answer
