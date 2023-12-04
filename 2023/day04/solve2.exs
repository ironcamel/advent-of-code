defmodule Main do
  def main() do
    cards = "input-large.txt" |> parse_cards

    1..map_size(cards)
    |> Enum.reduce(cards, fn id, acc ->
      %{win_set: win_set, nums: nums, cnt: cnt} = acc[id]
      num_matches = Enum.count(nums, fn num -> MapSet.member?(win_set, num) end)
      Enum.reduce(1..num_matches//1, acc, fn i, acc -> inc_card_cnt(acc, acc[id + i], cnt) end)
    end)
    |> count_cards
  end

  def inc_card_cnt(cards, card, inc), do: Map.put(cards, card.id, %{card | cnt: card.cnt + inc})

  def count_cards(cards), do: cards |> Map.values() |> Enum.map(& &1.cnt) |> Enum.sum()

  def parse_cards(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [id_label, winners, nums] = String.split(line, [":", "|"])
      id = Regex.run(~r/\d+/, id_label) |> hd |> String.to_integer()
      win_set = winners |> String.split() |> MapSet.new()
      {id, win_set, String.split(nums)}
    end)
    |> Enum.reduce(%{}, fn {id, win_set, nums}, acc ->
      Map.put(acc, id, %{id: id, win_set: win_set, nums: nums, cnt: 1})
    end)
  end
end

Main.main() |> IO.puts()

# 30 - input-small.txt answer
# 15455663 - input-large.txt answer
