defmodule Main do
  def main() do
    # "input-large.txt"
    # records = "foo.txt" |> parse_input()

    #"foo.txt"
    #"input-small.txt"
    #|> parse_input()
    #|> Enum.map(fn {record, sizes} -> search(record, sizes) end)

    #line = "???.### 1,1,3"
    #line = ".??..??...?##. 1,1,3"
    #line = "?#?#?#?#?#?#?#? 1,3,1,6"
    #line = "????.#...#... 4,1,1"
    #line = "????.######..#####. 1,6,5"
    line = "?###???????? 3,2,1"
    {record, sizes} = parse_line(line)
    search(record, sizes)
  end

  def search(cache \\ %{}, record, sizes, sum \\ 0) do
    #p "zzz 100 search"
    key = {record, sizes}

    if cache[key] do
      p "cache hit, yay"
      {cache, cache[key]}
    else
      val = search2(cache, record, sizes, sum)
      cache = Map.put(cache, key, val)
      {cache, val}
    end
  end

  def search2(_cache, [], [], sum), do: sum + 1
  def search2(_cache, [], _sizes, sum), do: sum

  def search2(_cache, record, [], sum) do
    if not Enum.any?(record, &(&1 == "#")) do
      sum + 1
    else
      sum
    end
  end

  def search2(cache, record, sizes, sum) do
    p [record, sizes, sum]
    case hd(record) do
      "." -> search(cache, tl(record), sizes, sum) |> elem(1)
      "#" -> handle_hash(cache, record, sizes, sum)
      "?" ->
        {cache, val} = search(cache, tl(record), sizes, sum)
        val + handle_hash(cache, record, sizes, sum)
    end
  end

  def handle_hash(cache, record, [size | sizes], sum) do
    check_size = record |> Enum.take(size) |> Enum.all?(&(&1 in ["#", "?"]))
    has_sep = Enum.at(record, size) in ["?", ".", nil]
    if check_size and has_sep do
      search(cache, record |> Enum.split(size+1) |> elem(1), sizes, sum) |> elem(1)
    else
      sum
    end
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> parse_line(line) end)
  end

  def parse_line(line) do
    [springs, counts] = String.split(line)
    springs = String.codepoints(springs)
    counts = counts |> String.split(",") |> Enum.map(&String.to_integer/1)
    {springs, counts}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> IO.inspect()

# 21 input-small.txt answer
# 7221 - input-large.txt answer
