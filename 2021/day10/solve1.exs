defmodule Main do
  def main() do
    "input-large.txt"
    # "input-small.txt"
    |> parse_input()
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn c ->
      case c do
        ")" -> 3
        "]" -> 57
        "}" -> 1197
        ">" -> 25137
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def parse_line(line) do
    Enum.reduce_while(line, [], fn c, acc ->
      if c in ~w|( [ { <| do
        {:cont, [c | acc]}
      else
        case c do
          ")" ->
            if hd(acc) == "(" do
              {:cont, tl(acc)}
            else
              {:halt, c}
            end

          "]" ->
            if hd(acc) == "[" do
              {:cont, tl(acc)}
            else
              {:halt, c}
            end

          "}" ->
            if hd(acc) == "{" do
              {:cont, tl(acc)}
            else
              {:halt, c}
            end

          ">" ->
            if hd(acc) == "<" do
              {:cont, tl(acc)}
            else
              {:halt, c}
            end
        end
      end
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
  end

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end
end

Main.main() |> Main.p()

# 26397 - input-small.txt answer
# 323691 - input-large.txt answer
