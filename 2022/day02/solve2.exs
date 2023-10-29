defmodule Main do
  @value %{"A" => 1, "B" => 2, "C" => 3}
  @score %{"X" => 0, "Y" => 3, "Z" => 6};
  @choice %{
    "A" => %{"X" => "C", "Y" => "A", "Z" => "B"},
    "B" => %{"X" => "A", "Y" => "B", "Z" => "C"},
    "C" => %{"X" => "B", "Y" => "C", "Z" => "A"},
  }

  def go() do
    # "input-small.txt"
    "input-large.txt"
    |> File.read!()
    |> String.split()
    |> Enum.chunk_every(2)
    |> Enum.map(&calc(&1))
    |> Enum.sum()
  end

  def calc([a, b]) do
    @value[@choice[a][b]] + @score[b]
  end

end

IO.puts(Main.go())

# 12 - input-small.txt answer
# 11618 - input-large.txt answer
