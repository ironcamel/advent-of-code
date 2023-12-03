defmodule Main do
  @unit_circle [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  def main() do
    rows = parse_input("input-large.txt")

    schema =
      Enum.reduce(rows, %{}, fn {row, i}, acc ->
        Enum.reduce(row, acc, fn {c, j}, acc2 -> Map.put(acc2, {i, j}, c) end)
      end)

    parts_map = create_parts_map(rows, schema)

    schema
    |> Enum.filter(fn {_point, c} -> c == "*" end)
    |> Enum.map(fn {{i, j}, _c} ->
      @unit_circle
      |> Enum.map(fn {i_inc, j_inc} -> parts_map[{i + i_inc, j + j_inc}] end)
      |> Enum.filter(& &1)
      |> Enum.uniq()
      |> then(fn parts -> gear_ratio(parts, schema) end)
    end)
    |> Enum.sum()
  end

  def is_part_number(points, schema) do
    Enum.any?(points, fn {i, j} ->
      Enum.any?(@unit_circle, fn {i_inc, j_inc} -> is_symbol(schema[{i + i_inc, j + j_inc}]) end)
    end)
  end

  def is_d(c), do: c =~ ~r/\d/

  def is_symbol(c), do: c && c =~ ~r/\D/ && c != "."

  def gear_ratio(parts, _schema) when length(parts) != 2, do: 0

  def gear_ratio(parts, schema) do
    parts
    |> Enum.map(fn points ->
      points |> Enum.map_join(fn point -> schema[point] end) |> String.to_integer()
    end)
    |> Enum.product()
  end

  # Returns a map containing all the part numbers, keyed by the coordinates of
  # the part number. A part number that is 3 digits long will have 3 entries in
  # this map. The value is stored as a list of coordinates.
  def create_parts_map(rows, schema) do
    rows
    |> Enum.reduce([], fn {row, i}, acc ->
      row
      |> Enum.chunk_by(fn {c, _j} -> is_d(c) end)
      |> Enum.filter(fn [{c, _j} | _] -> is_d(c) end)
      |> Enum.map(fn chunks ->
        Enum.map(chunks, fn {_c, j} -> {i, j} end)
      end)
      |> Enum.filter(&is_part_number(&1, schema))
      |> Enum.concat(acc)
    end)
    |> Enum.reduce(%{}, fn part_points, acc ->
      Enum.reduce(part_points, acc, fn point, acc2 ->
        Map.put(acc2, point, part_points)
      end)
    end)
  end

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

# 467835 - input-small.txt answer
# 75805607 - input-large.txt answer
