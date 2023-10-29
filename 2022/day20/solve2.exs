defmodule Main do
  def go() do
    #data_list = "input-small.txt" |> parse_input
    data_list = "input-large.txt" |> parse_input
    data_tuple = List.to_tuple(data_list)
    index_map = data_list |> Enum.with_index(fn _, i -> {i, i} end) |> Map.new()

    #mix(data_list, index_map)
    Enum.reduce(1..10, index_map, fn _, acc ->
      mix(data_list, acc)
    end)
    |> calc(data_tuple)
  end

  def mix(data_list, index_map) do
    size = length data_list
    data_list
    |> Enum.with_index()
    |> Enum.reduce(index_map, fn {n, i}, acc ->
      p "moving #{n}"
      n = Integer.mod(n, size-1);
      old_i = acc[i]
      new_i = get_new_i(old_i, n, size)
      p "i: #{i}, old_i: #{old_i}, new_i: #{new_i}"

      new_pos = 
        acc
        |> Enum.filter(fn {_k, v} -> v == old_i end)
        |> Enum.map(fn {k, _v} -> {k, new_i} end)
        |> Map.new

      acc =
        acc
        |> shift_indexes(old_i, new_i)
        |> p
        |> Map.merge(new_pos)
        |> p
      # print data_list, acc
      p ""
      acc
    end)
  end

  def calc(index_map, data_tuple) do
    size = tuple_size(data_tuple)
    list =
      index_map
      |> Enum.sort(fn {_, a}, {_, b} -> a <= b end)
      |> Enum.map(fn {i, _} -> elem(data_tuple, i) end)

    i0 = Enum.find_index(list, fn x -> x == 0 end)
    final_tuple = List.to_tuple(list)

    for n <- [1000, 2000, 3000] do
      elem(final_tuple, rem(i0 + n, size))
    end
    |> dbg()
    |> Enum.sum()
  end

  def get_new_i(old_i, n, size) when old_i + n >= size, do: old_i + n - size + 1
  def get_new_i(old_i, n, _size), do: old_i + n

  def shift_indexes(index_map, i1, i2) when i1 == i2, do: index_map

  def shift_indexes(index_map, i1, i2) when i1 > i2, do: shift_indexes(index_map, i2, i1, 2)

  def shift_indexes(index_map, i1, i2, adj \\ 0) do
    p [:shift_indexes, index_map, i1, i2]
    shifted = 
      index_map
      |> Enum.filter(fn {_k, v} -> v in i1..i2 end)
      |> Enum.map(fn {k, v} -> {k, v-1+adj} end)
      |> Map.new
    Map.merge(index_map, shifted)
  end

  def print(data, index_map) when is_list(data), do: print(List.to_tuple(data), index_map)

  def print(data, index_map) do
    index_map
    |> Enum.sort(fn {_, a}, {_, b} -> a <= b end)
    |> Enum.map(fn {i, _} -> elem(data, i) end)
    |> p
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
    |> Enum.map(&(&1 * 811_589_153))
  end

  def p(o) do
    o
    # IO.inspect(o, charlists: :as_lists)
  end
end

IO.inspect(Main.go())

# 1623178306 - input-small.txt answer
# 8927480683 - input-large.txt answer
