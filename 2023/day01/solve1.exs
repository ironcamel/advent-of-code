defmodule Main do
  def go() do
    "input-large.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      digits = Regex.scan(~r/\d/, line)
      num1 = digits |> hd |> hd
      num2 = digits |> List.last() |> hd
      String.to_integer(num1 <> num2)
    end)
    |> Enum.sum()
  end
end

Main.go() |> IO.puts()

# 142 - input-small.txt answer
# 55123 - input-large.txt answer
