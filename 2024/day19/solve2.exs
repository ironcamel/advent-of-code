Mix.install([:memoize])

defmodule Main do
  use Memoize
  def main() do
    {patterns, designs} = parse_input("input-small.txt")
    #{patterns, designs} = parse_input("input-large.txt")

    match(patterns, "rrbgbr")
    designs
    |> Enum.map(fn design ->
      match(patterns, design)
    end)
    |> Enum.sum()
  end

    #if cache[design] do
    #  [cache[design]]
    #else
    #end

  defmemo match(_patterns, ""), do: 1

  defmemo match(patterns, design) do
    patterns
    |> Enum.filter(fn p -> String.starts_with?(design, p) end)
    |> Enum.map(fn pattern ->
      match(patterns, String.replace(design, ~r/^#{pattern}/, ""))
    end)
    |> Enum.sum()
  end

  def parse_input(path) do
    [part1, part2] =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n")

    patterns = String.split(part1, ", ")
    designs = String.split(part2, "\n", trim: true)
    {patterns, designs}
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 16 - input-small.txt answer
# 1016700771200474 - input-large.txt answer
