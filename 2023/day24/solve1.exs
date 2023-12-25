Mix.install [:nx]

defmodule Main do
  def main() do
    #stones = "input-small.txt" |> parse_input()
    stones = "input-large.txt" |> parse_input()

    for a <- stones, b <- stones, a != b do
      [a, b] |> Enum.sort
    end
    |> Enum.uniq
    |> Enum.map(fn [a, b] -> check_stones(a, b) end)
    |> Enum.count(fn x -> x end)
  end

  #Hailstone A: 19, 13, 30 @ -2, 1, -2
  #Hailstone B: 18, 19, 22 @ -1, -1, -2
  def check_stones([xa0, ya0, _, xa, ya, _], [xb0, yb0, _, xb, yb, _]) do
    min = 200000000000000
    max = 400000000000000
    t1 = Nx.tensor([
      [xa, -xb],
      [ya, -yb],
    ])
    t2 = Nx.tensor([-xa0 + xb0, -ya0 + yb0])

    solution =
      try do
        Nx.LinAlg.solve(t1, t2) |> Nx.to_list
      rescue
        _ -> nil
      end

    case solution do
      [a, b] ->
        x = (a * xa + xa0)
        y = (a * ya + ya0)
        min <= x and x <= max and min <= y and y <= max and a > 0 and b > 0
      nil ->
        false
    end
  end



  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.split([", ", " @ "]) |> Enum.map(&String.to_integer/1)
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()
