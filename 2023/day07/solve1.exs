defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.sort(fn {hand_a, _, type_a}, {hand_b, _, type_b} ->
      if type_a == type_b, do: hand_a <= hand_b, else: type_a <= type_b
    end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, bid, _rank}, i} -> bid * i end)
    |> Enum.sum()
  end

  def card_type(hand) do
    case hand |> Enum.sort() |> Enum.frequencies() |> Map.values() |> Enum.sort() do
      [5] -> 5
      [1, 4] -> 4
      [2, 3] -> 3.5
      [1, 1, 3] -> 3
      [1, 2, 2] -> 2
      [1, 1, 1, 2] -> 1
      _ -> 0.5
    end
  end

  def card_val("A"), do: 14
  def card_val("K"), do: 13
  def card_val("Q"), do: 12
  def card_val("J"), do: 11
  def card_val("T"), do: 10
  def card_val(c), do: String.to_integer(c)

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line)
      hand = hand |> String.codepoints() |> Enum.map(fn c -> card_val(c) end)
      {hand, String.to_integer(bid), card_type(hand)}
    end)
  end
end

Main.main() |> IO.puts()

# 6440 - input-small.txt answer
# 249726565 - input-large.txt answer
