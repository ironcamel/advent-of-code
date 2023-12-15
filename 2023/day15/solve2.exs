defmodule Main do
  def main() do
    map =
      "input-small.txt"
      #"input-large.txt"
      |> parse_input()
      |> Enum.reduce(%{}, fn cmd, acc ->
        #dbg
        do_cmd(cmd, acc)
        #|> dbg
      end)

    map
    |> Enum.map(fn {key, val} ->
      val
      |> Enum.reverse()
      |> Enum.with_index(1)
      |> Enum.map(fn {{_, n}, i} -> (key + 1) * i * String.to_integer(n) end)
      |> Enum.sum()
    end)
    |> Enum.sum()

  end

  def do_cmd(cmd, map \\ %{}) do
    case Regex.run(~r/(.+)=(\d)/, cmd) do
      [_, key, n] -> do_cmd(key, :put, n, map)
      _ -> cmd |> String.trim("-") |> do_cmd(:del, map)
    end
  end

  def do_cmd(key, :put, n, map) do
    key_hash = hash(key)
    val = {key, n}
    list = map[key_hash]
    if list do
      i = Enum.find_index(list, fn {a, _b} -> a == key end)
      if i do
        list = List.replace_at(list, i, val)
        Map.put(map, key_hash, list)
      else
        #list = list ++ [val]
        list = [val | list]
        Map.put(map, key_hash, list)
      end
    else
      Map.put(map, key_hash, [val])
    end
  end

  def do_cmd(key, :del, map) do
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

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split(",")
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> Main.p

# 145 - input-small.txt answer
# 251353 - input-large.txt answer
