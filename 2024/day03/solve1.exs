data = "input-large.txt" |> File.read!()

~r/mul\((\d+),(\d+)\)/
|> Regex.scan(data)
|> Enum.map(fn [_, x, y] -> String.to_integer(x) * String.to_integer(y) end)
|> Enum.sum()
|> IO.puts()

# 161 - input-small.txt answer
# 187825547 - input-large.txt answer
