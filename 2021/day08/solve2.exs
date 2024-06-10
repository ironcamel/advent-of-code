defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn {a, b} -> solve(a, b) end)
    |> Enum.sum()
  end

  def solve(patterns, output) do
    pattern_map =
      patterns
      |> Enum.reduce(%{}, fn pat, acc ->
        case String.length(pat) do
          2 -> Map.put(acc, pat, 1)
          3 -> Map.put(acc, pat, 7)
          4 -> Map.put(acc, pat, 4)
          7 -> Map.put(acc, pat, 8)
          _ -> acc
        end
      end)

    num_map = pattern_map |> Enum.map(fn {k, v} -> {v, k} end) |> Map.new()

    pattern_map =
      patterns
      |> Enum.reduce(pattern_map, fn pat, acc ->
        case String.length(pat) do
          6 ->
            set1 = num_map[1] |> String.codepoints() |> MapSet.new()
            set6 = pat |> String.codepoints() |> MapSet.new()

            if MapSet.size(MapSet.difference(set1, set6)) == 1 do
              Map.put(acc, pat, 6)
            else
              acc
            end

          _ ->
            acc
        end
      end)

    num_map = pattern_map |> Enum.map(fn {k, v} -> {v, k} end) |> Map.new()

    pattern_map =
      patterns
      |> Enum.reduce(pattern_map, fn pat, acc ->
        case String.length(pat) do
          6 ->
            set4 = num_map[4] |> String.codepoints() |> MapSet.new()
            set6 = pat |> String.codepoints() |> MapSet.new()

            cond do
              acc[pat] == 6 -> acc
              MapSet.size(MapSet.difference(set4, set6)) == 0 -> Map.put(acc, pat, 9)
              true -> Map.put(acc, pat, 0)
            end

          _ ->
            acc
        end
      end)

    num_map = pattern_map |> Enum.map(fn {k, v} -> {v, k} end) |> Map.new()

    pattern_map =
      patterns
      |> Enum.reduce(pattern_map, fn pat, acc ->
        if String.length(pat) == 5 do
          set6 = num_map[6] |> String.codepoints() |> MapSet.new()
          set7 = num_map[7] |> String.codepoints() |> MapSet.new()
          set5 = pat |> String.codepoints() |> MapSet.new()

          cond do
            MapSet.size(MapSet.difference(set7, set5)) == 0 -> Map.put(acc, pat, 3)
            MapSet.size(MapSet.difference(set5, set6)) == 0 -> Map.put(acc, pat, 5)
            true -> Map.put(acc, pat, 2)
          end
        else
          acc
        end
      end)

    pattern_map =
      Enum.map(pattern_map, fn {pat, n} ->
        pat = pat |> String.codepoints() |> Enum.sort() |> Enum.join()
        {pat, n}
      end)
      |> Map.new()

    output =
      Enum.map(output, fn pat -> pat |> String.codepoints() |> Enum.sort() |> Enum.join() end)

    output
    |> Enum.map(fn pat -> pattern_map[pat] end)
    |> Enum.join("")
    |> String.to_integer()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" | ") end)
    |> Enum.map(fn [a, b] -> {String.split(a, " "), String.split(b, " ")} end)
  end
end

Main.main() |> IO.puts()

# 61229 - input-small.txt answer
# 1091609 - input-large.txt answer
