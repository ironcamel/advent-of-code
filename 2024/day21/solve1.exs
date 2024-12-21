defmodule Main do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}

  def main() do
    #codes = parse_input("input-small.txt")
    #codes = parse_input("foo.txt")
    codes = parse_input("input-large.txt")

    codes
    |> Enum.map(fn code ->
      l =
        code
        |> enter_code()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn code -> enter_code(code) end)
        |> List.flatten()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn code -> enter_code(code, false) end)
        |> List.flatten()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&length/1)
        |> Enum.min()
      
      n = code |> Enum.filter(fn c -> c =~ ~r/\d/ end) |> Enum.join() |> String.to_integer()
      n * l
    end)
    |> Enum.sum()
    #42
    #permutations(1..10 |> Enum.to_list) |> length
    #permutations(List.duplicate(">", 5) ++ List.duplicate("^", 5)) |> length
    #permutations(List.duplicate(">", 4) ++ List.duplicate("^", 3)) |> length
    #permutations(List.duplicate(">", 4) ++ List.duplicate("^", 3)) |> Enum.uniq() |> length
  end

  def cost(code) do
    buttons =
      code
      |> enter_code()
      |> Enum.map(&Tuple.to_list/1)
  end

  def enter_code(code, gen_perm \\ true, path \\ [], cur \\ {3, 2})

  def enter_code([], _gen_perm, path, _cur), do: path |> List.to_tuple()

  def enter_code([c | code], gen_perm, path, {i0, j0} = cur) do
    #dbg()
    #p path
    {i1, j1} = new_pos = pos_for(c)
    #dist = taxi_dist(cur, new_pos)
    vert_dist = i1 - i0
    horz_dist = j1 - j0
    vert_c = if vert_dist > 0, do: "v", else: "^"
    horz_c = if horz_dist > 0, do: ">", else: "<"


    permutations(abs(vert_dist), vert_c, abs(horz_dist), horz_c)
    |> Enum.reject(fn buttons ->
      buttons
      |> Enum.reduce([cur], fn arrow, acc->
        new_pos = arrow |> arrow_to_dir() |> add_points(hd(acc))
        [new_pos | acc]
      end)
      |> Enum.any?(fn p -> p == {3, 0} end)
    end)
    |> Enum.map(fn buttons ->
      enter_code(code, gen_perm, path ++ buttons ++ ["A"], new_pos)
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

  def permutations(x, c1, y, c2) do
    [
      List.duplicate(c1, x) ++ List.duplicate(c2, y),
      List.duplicate(c2, y) ++ List.duplicate(c1, x),
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
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.codepoints()
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 126384 - input-small.txt answer
# 137870 - input-large.txt answer
