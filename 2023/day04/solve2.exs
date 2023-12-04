defmodule Main do
  def main() do
    "input-large.txt" |> parse_cards |> process(1)
  end

  def process(cards, id) when id > map_size(cards), do: count_cards(cards)

  def process(cards, id) do
    {win_set, nums, cnt} = cards[id]
    num_matches = Enum.count(nums, fn num -> MapSet.member?(win_set, num) end)

    1..num_matches//1
    |> Enum.reduce(cards, fn i, acc -> inc_card_cnt(acc, id + i, cnt) end)
    |> process(id + 1)
  end

  def inc_card_cnt(cards, id, inc) do
    {win_set, nums, cnt} = cards[id]
    Map.put(cards, id, {win_set, nums, cnt + inc})
  end

  def count_cards(cards), do: cards |> Enum.map(fn {_key, {_, _, cnt}} -> cnt end) |> Enum.sum()

  def parse_cards(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [id, winners, my_nums] = String.split(line, [":", "|"])
      id = Regex.run(~r/\d+/, id) |> hd |> String.to_integer()
      win_set = winners |> String.split() |> MapSet.new()
      {id, win_set, String.split(my_nums)}
    end)
    |> Enum.reduce(%{}, fn {id, win, nums}, acc ->
      Map.put(acc, id, {win, nums, 1})
    end)
  end
end

Main.main() |> IO.puts()

# 30 - input-small.txt answer
# 15455663 - input-large.txt answer
