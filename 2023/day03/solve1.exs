defmodule Main do
  def main() do
    rows = parse_input("input-large.txt")

    schema =
      Enum.reduce(rows, %{}, fn {row, i}, acc ->
        Enum.reduce(row, acc, fn {c, j}, acc2 -> Map.put(acc2, {i, j}, c) end)
      end)

    rows
    |> Enum.reduce([], fn {row, i}, acc ->
      row
      |> Enum.chunk_by(fn {c, _j} -> is_d(c) end)
      |> Enum.filter(fn [{c, _j} | _] -> is_d(c) end)
      |> Enum.map(fn chunks ->
        Enum.map(chunks, fn {_c, j} -> {i, j} end)
      end)
      |> Enum.filter(fn part_num -> is_part_number(part_num, schema) end)
      |> Enum.concat(acc)
    end)
    |> Enum.map(fn points ->
      points
      |> Enum.map_join(fn point -> schema[point] end)
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def is_part_number(points, schema) do
    Enum.any?(points, fn {i, j} ->
      [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
      |> Enum.any?(fn {i_inc, j_inc} -> is_symbol(schema[{i + i_inc, j + j_inc}]) end)
    end)
  end

  def is_d(c), do: c =~ ~r/\d/

  def is_symbol(c), do: c && c =~ ~r/\D/ && c != "."

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {line, i} ->
      {line |> String.codepoints() |> Enum.with_index(), i}
    end)
  end
end

Main.main() |> IO.puts()

# 4361 - input-small.txt answer
# 525911 - input-large.txt answer
