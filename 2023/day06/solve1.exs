defmodule Main do

  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn race -> ways_to_win(race) end)
    |> Enum.product()
  end

  def ways_to_win({t, record_d}) do
    Enum.count(1..t, fn speed -> speed * (t - speed) > record_d end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(":")
      |> List.last()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
  end
end

Main.main() |> IO.puts()

# 288 - input-small.txt answer
# 393120 - input-large.txt answer
