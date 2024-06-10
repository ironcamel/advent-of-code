defmodule Main do
  @nsew [{-1, 0}, {1, 0}, {0, 1}, {0, -1}]

  def main() do
    grid = "input-large.txt" |> parse_input()

    grid
    |> Enum.filter(fn {pos, h} ->
      Enum.all?(@nsew, fn delta ->
        val = grid[add_delta(pos, delta)]
        val == nil or val > h
      end)
    end)
    |> Enum.map(fn {_pos, h} -> h + 1 end)
    |> Enum.sum
  end

  def add_delta({i, j}, {di, dj}), do: {i + di, j + dj}

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {val, j} -> {{i, j}, String.to_integer(val)} end)
    end)
    |> Map.new()
  end
end

Main.main() |> IO.puts()

# 15 - input-small.txt answer
# 541 - input-large.txt answer
