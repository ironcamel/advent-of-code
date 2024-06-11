defmodule Main do
  @unit_circle [{-1, 0}, {1, 0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}]

  def main() do
    data = "input-large.txt" |> parse_input()
    num_rounds = 100

    {_data, cnt} =
      Enum.reduce(1..num_rounds, {data, 0}, fn _i, {data, cnt} ->
        {data, num_flashes} = flash(data)
        {data, cnt + num_flashes}
      end)

    cnt
  end

  def add_delta({i, j}, {di, dj}), do: {i + di, j + dj}

  def flash(data, seen \\ %{}, total_flashes \\ 0, cnt \\ nil)

  def flash(data, _seen, total_flashes, 0) do
    data =
      data
      |> Enum.map(fn {pos, val} -> if val > 9, do: {pos, 0}, else: {pos, val} end)
      |> Map.new()

    {data, total_flashes}
  end

  def flash(data, seen, total_flashes, cnt) do
    data =
      if cnt == nil do
        Enum.map(data, fn {{i, j}, val} -> {{i, j}, val + 1} end) |> Map.new()
      else
        data
      end

    flashes =
      data
      |> Enum.filter(fn {_pos, val} -> val > 9 end)
      |> Enum.reject(fn {pos, _val} -> seen[pos] end)

    seen = Enum.reduce(flashes, seen, fn {pos, _val}, acc -> Map.put(acc, pos, true) end)

    data =
      flashes
      |> Enum.flat_map(fn {pos, _val} ->
        @unit_circle
        |> Enum.map(fn delta -> add_delta(pos, delta) end)
        |> Enum.filter(fn pos -> data[pos] end)
      end)
      |> Enum.frequencies()
      |> Enum.reduce(data, fn {pos, inc}, acc ->
        Map.put(acc, pos, acc[pos] + inc)
      end)

    flash(data, seen, total_flashes + length(flashes), length(flashes))
  end

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

# 1656 - input-small.txt answer
# 1717 - input-large.txt answer
