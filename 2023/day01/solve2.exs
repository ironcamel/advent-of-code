defmodule Main do
  def go() do
    pattern = ~S(\d|one|two|three|four|five|six|seven|eight|nine)
    re1 = Regex.compile!(pattern)
    re2 = Regex.compile!(".*(#{pattern})")

    "input-large.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      num1 = Regex.run(re1, line) |> hd |> to_digit
      num2 = Regex.run(re2, line) |> List.last() |> to_digit
      String.to_integer(num1 <> num2)
    end)
    |> Enum.sum()
  end

  def to_digit(s) when byte_size(s) == 1, do: s

  def to_digit(s) do
    case s do
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
    end
  end
end

Main.go() |> IO.puts()

# 55260 - input-large.txt answer
