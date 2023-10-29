defmodule Main do
  def go() do
    values = %{"X" => 1, "Y" => 2, "Z" => 3}

    score = %{
      "A" => %{"X" => 3, "Y" => 6, "Z" => 0},
      "B" => %{"X" => 0, "Y" => 3, "Z" => 6},
      "C" => %{"X" => 6, "Y" => 0, "Z" => 3},
    }

    rounds = 
      "input-large.txt"
      # rounds = "input-small.txt"
      |> File.read!()
      |> String.split()
      |> Enum.chunk_every(2)

    sum1 =
      rounds
      |> Enum.map(&(score[hd &1][hd tl &1]))
      |> Enum.sum()

    sum2 =
      rounds
      |> Enum.map(&(values[hd tl &1]))
      |> Enum.sum()

    sum1 + sum2
  end
end

IO.puts(Main.go())

# 15 - small input answer
# 12772 - large input answer
