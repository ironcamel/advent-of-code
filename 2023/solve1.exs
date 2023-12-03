defmodule Main do

  def main() do
    # lines = "input-large.txt" |> parse_input
    lines = "input-small.txt" |> parse_input

  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {line, i} ->
      {line |> String.codepoints() |> Enum.with_index(), i}
    end)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> IO.inspect()
