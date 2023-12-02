defmodule Main do
  def go() do
    "input-large.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&create_game(&1))
    |> Enum.map(&calc_min_cubes(&1))
    |> Enum.map(fn min_cubes -> min_cubes |> Map.values() |> Enum.product() end)
    |> Enum.sum()
  end

  def create_game(line) do
    line
    |> String.split([": ", "; "])
    |> tl
    |> Enum.map(fn rounds_str ->
      String.split(rounds_str, ", ")
      |> Enum.reduce(%{}, fn s, acc ->
        [num, color] = String.split(s)
        Map.put(acc, color, String.to_integer(num))
      end)
    end)
  end

  def calc_min_cubes(game) do
    Enum.reduce(game, %{"red" => 0, "green" => 0, "blue" => 0}, fn round, acc ->
      Enum.reduce(round, acc, fn {color, num}, acc2 ->
        if num > acc2[color] do
          Map.put(acc2, color, num)
        else
          acc2
        end
      end)
    end)
  end
end

Main.go() |> IO.puts()

# 2286 - input-small.txt answer
# 72422 - input-large.txt answer
