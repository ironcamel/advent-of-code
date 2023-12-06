defmodule Main do
  def main() do
    "input-large.txt" |> parse_input() |> ways_to_win()
  end

  def ways_to_win([t, record_d]) do
    Enum.count(1..t, fn speed -> speed * (t - speed) > record_d end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line) |> List.flatten() |> Enum.join() |> String.to_integer()
    end)
  end
end

Main.main() |> IO.puts()

# 71503 - input-small.txt answer
# 36872656 - input-large.txt answer
