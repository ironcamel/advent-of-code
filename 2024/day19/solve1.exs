defmodule Main do
  def main() do
    #{patterns, designs} = parse_input("input-small.txt")
    {patterns, designs} = parse_input("input-large.txt")

    designs
    |> Enum.count(fn design ->
      match(patterns, design)
    end)

  end

  def match(patterns, ""), do: true

  def match(patterns, design) do
    Enum.filter(patterns, fn p -> String.starts_with?(design, p) end)
    |> Enum.any?(fn pattern ->
      match(patterns, String.trim(design, pattern))
    end)
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
