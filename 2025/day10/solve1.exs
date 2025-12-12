Mix.install([:combination])

defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.map(fn {n, buttons} ->
      Enum.find(1..length(buttons), fn i ->
        buttons
        |> Combination.combine(i)
        |> Enum.any?(fn nums ->
          Enum.reduce(nums, 0, fn x, acc -> Bitwise.bxor(acc, x) end) == n
        end)
      end)
    end)
    |> Enum.sum()
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, n, buttons] = Regex.run(~r/\[(.+)\] (.+) \{/, line)
      num_bits = String.length(n)
      zeros = List.duplicate("0", num_bits)
      n = n |> String.replace(".", "0") |> String.replace("#", "1") |> String.to_integer(2)

      buttons =
        buttons
        |> String.replace("(", "")
        |> String.replace(")", "")
        |> String.split()
        |> Enum.map(fn s ->
          s
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
          |> Enum.reduce(zeros, fn i, acc ->
            List.replace_at(acc, i, "1")
          end)
          |> Enum.join()
          |> String.to_integer(2)
        end)

      {n, buttons}
    end)
  end
end

Main.main() |> IO.puts()

# 7 - input-small.txt answer
# 538 - input-large.txt answer
