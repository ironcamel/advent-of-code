defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.reduce(%{}, fn cmd, acc -> do_cmd(cmd, acc) end)
    |> Enum.flat_map(fn {key, list} ->
      list
      |> Enum.reverse()
      |> Enum.with_index(1)
      |> Enum.map(fn {{_, n}, i} -> (key + 1) * i * String.to_integer(n) end)
    end)
    |> Enum.sum()
  end

  def do_cmd(cmd, map) do
    case Regex.run(~r/(.+)=(\d)/, cmd) do
      [_, key, n] -> put(map, key, n)
      _ -> del(map, String.trim(cmd, "-"))
    end
  end

  def put(map, key, n) do
    key_hash = hash(key)
    val = {key, n}
    list = map[key_hash]

    if list do
      i = Enum.find_index(list, fn {a, _b} -> a == key end)

      if i do
        Map.put(map, key_hash, List.replace_at(list, i, val))
      else
        Map.put(map, key_hash, [val | list])
      end
    else
      Map.put(map, key_hash, [val])
    end
  end

  def del(map, key) do
    key_hash = hash(key)
    list = map[key_hash]

    if list do
      list = Enum.reject(list, fn {a, _b} -> a == key end)
      Map.put(map, key_hash, list)
    else
      map
    end
  end

  def hash(s) do
    s |> String.to_charlist() |> Enum.reduce(0, fn c, acc -> rem((acc + c) * 17, 256) end)
  end

  def parse_input(path), do: path |> File.read!() |> String.trim() |> String.split(",")
end

Main.main() |> IO.puts()

# 145 - input-small.txt answer
# 251353 - input-large.txt answer
