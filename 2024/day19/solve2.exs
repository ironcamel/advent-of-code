Mix.install([:memoize])

defmodule Main do
  use Memoize

  def main() do
    {patterns, designs} = parse_input("input-large.txt")
    designs |> Enum.map(fn design -> match(patterns, design) end) |> Enum.sum()
  end

  defmemo(match(_patterns, ""), do: 1)

  defmemo match(patterns, design) do
    patterns
    |> Enum.filter(fn p -> String.starts_with?(design, p) end)
    |> Enum.map(fn pattern ->
      match(patterns, String.replace(design, ~r/^#{pattern}/, ""))
    end)
    |> Enum.sum()
  end

  def parse_input(path) do
    [part1, part2] = path |> File.read!() |> String.split("\n\n")
    patterns = String.split(part1, ", ")
    designs = String.split(part2, "\n", trim: true)
    {patterns, designs}
  end
end

Main.main() |> IO.puts()

# 16 - input-small.txt answer
# 1016700771200474 - input-large.txt answer
