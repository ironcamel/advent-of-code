defmodule Main do
  def main() do
    {patterns, designs} = parse_input("input-large.txt")
    Enum.count(designs, fn design -> match(patterns, design) end)
  end

  def match(_patterns, ""), do: true

  def match(patterns, design) do
    Enum.filter(patterns, fn p -> String.starts_with?(design, p) end)
    |> Enum.any?(fn pattern ->
      match(patterns, String.trim(design, pattern))
    end)
  end

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.split("\n\n")
    patterns = String.split(part1, ", ")
    designs = String.split(part2, "\n", trim: true)
    {patterns, designs}
  end
end

Main.main() |> IO.puts()

# 6 - input-small.txt answer
# 213 - input-large.txt answer
