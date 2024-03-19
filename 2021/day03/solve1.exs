defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn row -> round(Enum.sum(row) / length(row)) end)
    |> then(fn gamma ->
      eps = Enum.map(gamma, fn n -> if n == 1, do: 0, else: 1 end)
      to_i(gamma) * to_i(eps)
    end)
  end

  def to_i(row), do: row |> Enum.map(&Integer.to_string/1) |> Enum.join() |> String.to_integer(2)

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(fn row ->
      row |> Tuple.to_list() |> Enum.map(&String.to_integer/1)
    end)
  end
end

Main.main() |> IO.puts()

# 198 - input-small.txt answer
# 1131506 - input-large.txt answer
