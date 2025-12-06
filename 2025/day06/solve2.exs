lines = "input-large.txt" |> File.read!() |> String.split("\n", trim: true)
{lines, [ops]} = Enum.split(lines, -1)
ops = String.split(ops)

lines
|> Enum.map(&String.codepoints/1)
|> Enum.zip()
|> Enum.map(fn digits -> digits |> Tuple.to_list() |> Enum.join() |> String.trim() end)
|> Enum.chunk_by(fn s -> s == "" end)
|> Enum.reject(&(&1 == [""]))
|> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
|> Enum.zip(ops)
|> Enum.map(fn
  {vals, "+"} -> Enum.sum(vals)
  {vals, "*"} -> Enum.product(vals)
end)
|> Enum.sum()
|> IO.puts()

# 3263827 - input-small.txt answer
# 11386445308378 - input-large.txt answer
