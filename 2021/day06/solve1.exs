defmodule Main do
  def main() do
    fish = "input-large.txt" |> parse_input()
    data = Map.from_keys(Range.to_list(0..8), 0)

    data =
      Enum.reduce(fish, data, fn n, acc ->
        Map.put(acc, n, acc[n] + 1)
      end)

    num_days = 80

    data =
      Enum.reduce(1..div(num_days, 7), data, fn _, acc ->
        sim_week(acc)
      end)

    sum = data |> Map.values() |> Enum.sum()

    0..(rem(num_days, 7) - 1)
    |> Enum.reduce(sum, fn i, acc ->
      acc + data[i]
    end)
  end

  def sim_week(data) do
    Enum.reduce(data, data, fn {n, cnt}, acc ->
      case n do
        7 ->
          acc
          |> Map.put(0, acc[0] + cnt)
          |> Map.put(7, acc[7] - cnt)

        8 ->
          acc
          |> Map.put(1, acc[1] + cnt)
          |> Map.put(8, acc[8] - cnt)

        _ ->
          new_key = rem(n + 2, 9)
          Map.put(acc, new_key, acc[new_key] + cnt)
      end
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

Main.main() |> IO.puts()

# 5934 - input-small.txt answer
# 351188 - input-large.txt answer
