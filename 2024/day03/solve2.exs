data = "input-large.txt" |> File.read!() |> String.replace(~r/don't\(\).*?do\(\)/s, "")

~r/mul\((\d+),(\d+)\)/
|> Regex.scan(data)
|> Enum.map(fn [_, x, y] -> String.to_integer(x) * String.to_integer(y) end)
|> Enum.sum()
|> IO.puts()

# 48 - input-small.txt answer
# 85508223 - input-large.txt answer
