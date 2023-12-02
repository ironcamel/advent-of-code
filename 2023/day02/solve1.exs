defmodule Main do
  @max_cubes %{"red" => 12, "green" => 13, "blue" => 14}

  def go() do
    "input-large.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&create_game(&1))
    |> Enum.filter(&check_game(&1))
    |> Enum.map(fn game -> game.id end)
    |> Enum.sum()
  end

  def create_game(line) do
    id = Regex.run(~r/\d+/, line) |> hd |> String.to_integer()

    rounds =
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

    %{id: id, rounds: rounds}
  end

  def check_game(%{rounds: rounds}) do
    Enum.all?(rounds, fn round ->
      Enum.all?(round, fn {color, num} -> num <= @max_cubes[color] end)
    end)
  end
end

Main.go() |> IO.puts()

# 8 - input-small.txt answer
# 2105 - input-large.txt answer
