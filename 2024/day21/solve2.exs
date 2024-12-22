Mix.install([:memoize])

defmodule Main do
  use Memoize

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn code ->
      n = code |> Enum.join() |> String.replace("A", "") |> String.to_integer()
      calc_len(code, 25) * n
    end)
    |> Enum.sum()
  end

  defmemo calc_len(code, depth) do
    ["A" | code]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] ->
      case depth do
        0 -> path_for(a, b) |> length()
        depth -> calc_len(path_for(a, b), depth - 1)
      end
    end)
    |> Enum.sum()
  end

  def path_for("A", "<"), do: ~w( v < < A )
  def path_for("^", "<"), do: ~w( v < A )
  def path_for("0", "1"), do: ~w( ^ < A )
  def path_for("0", "4"), do: ~w( ^ ^ < A )
  def path_for("0", "7"), do: ~w( ^ ^ ^ < A )
  def path_for("A", "1"), do: ~w( ^ < < A )
  def path_for("A", "4"), do: ~w( ^ ^ < < A )
  def path_for("A", "7"), do: ~w( ^ ^ ^ < < A )
  def path_for("1", "A"), do: ~w( > > v A )
  def path_for("4", "A"), do: ~w( > > v v A )
  def path_for("7", "A"), do: ~w( > > v v v A )
  def path_for("1", "0"), do: ~w( > v A )
  def path_for("4", "0"), do: ~w( > v v A )
  def path_for("7", "0"), do: ~w( > v v v A )
  def path_for("<", "A"), do: ~w( > > ^ A )
  def path_for("<", "^"), do: ~w( > ^ A )
  def path_for(a, b) when a == b, do: ["A"]

  def path_for(a, b) do
    {i0, j0} = pos_for(a)
    {i1, j1} = pos_for(b)
    vert_dist = i1 - i0
    horz_dist = j1 - j0
    vert_c = if vert_dist > 0, do: "v", else: "^"
    horz_c = if horz_dist > 0, do: ">", else: "<"
    vert_dist = abs(vert_dist)
    horz_dist = abs(horz_dist)

    # prefer < v ^ >   
    case horz_c do
      "<" -> List.duplicate(horz_c, horz_dist) ++ List.duplicate(vert_c, vert_dist)
      _ -> List.duplicate(vert_c, vert_dist) ++ List.duplicate(horz_c, horz_dist)
    end
    |> then(fn path -> path ++ ["A"] end)
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

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)
  end
end

Main.main() |> IO.puts()

# 170279148659464 - input-large.txt answer
