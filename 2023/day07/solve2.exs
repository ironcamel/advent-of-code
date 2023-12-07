defmodule Main do
  def main() do
    #hands = "input-large.txt" |> parse_input

    #"foo.txt"
    #"input-small.txt"
    "input-large.txt"
    |> parse_input()
    |> p()
    |> Enum.sort(fn {hand_a, _, type_a}, {hand_b, _, type_b} ->
      if type_a == type_b do
        hand_a <= hand_b
      else
        type_a <= type_b
      end
    end)
    |> p
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, bid, _rank}, i} -> bid * i end)
    |> Enum.sum()

  end

  def card_type(hand) do
    p hand
    {hand, jokers} = hand |> Enum.sort(fn a, b -> a >= b end) |> Enum.split_while(&(&1 != 1)) |> dbg
    chunk = fn hand, jokers ->
      hand = hand |> Enum.chunk_by(& &1) |> Enum.map(&length(&1)) |> Enum.sort() |> Enum.reverse()
      dbg
      num_jokers = length(jokers)
      hand = if hand == [], do: [0], else: hand
      [head | hand] = hand
      [head + num_jokers | hand] |> Enum.reverse()
    end

    case chunk.(hand, jokers) do
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
  def card_val("J"), do: 1
  def card_val("T"), do: 10
  def card_val(c), do: String.to_integer(c)

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line)
      hand =
        hand
        |> String.codepoints()
        |> Enum.map(fn c -> card_val(c) end)
        #|> Enum.sort(fn a, b -> a >= b end)

      {hand, String.to_integer(bid), card_type(hand)}
    end)
  end

  def p(o, opts \\ []) do
    o
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> IO.inspect()
#Main.main() |> Main.p()

# 6440 - input-small.txt answer
# 249726565 - input-large.txt answer
