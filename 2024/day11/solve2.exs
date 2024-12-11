defmodule Main do
  def main() do
    stones = parse_input("input-large.txt")

    1..75
    |> Enum.reduce(stones, fn _i, acc ->
      Enum.reduce(acc, %{}, fn {s, cnt}, acc ->
        Enum.reduce(blink(s), acc, fn s, acc ->
          if acc[s] do
            Map.put(acc, s, acc[s] + 1 * cnt)
          else
            Map.put(acc, s, 1 * cnt)
          end
        end)
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def blink("0"), do: ["1"]

  def blink(s) do
    if rem(String.length(s), 2) == 0 do
      {s1, s2} = s |> String.split_at(div(String.length(s), 2))
      [s1 |> String.to_integer() |> to_string(), s2 |> String.to_integer() |> to_string()]
    else
      [(String.to_integer(s) * 2024) |> to_string()]
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split()
    |> Enum.map(fn s -> {s, 1} end)
  end
end

Main.main() |> IO.puts()

# 228449040027793 - input-large.txt answer
