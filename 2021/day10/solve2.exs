defmodule Main do
  def main() do
    "input-large.txt"
    |> parse_input()
    |> Enum.filter(&check_line/1)
    |> Enum.map(fn line ->
      line
      |> Enum.reduce([], fn c, acc ->
        if c in ["(", "[", "{", "<"] do
          [c | acc]
        else
          tl(acc)
        end
      end)
      |> Enum.map(fn
        "(" -> ")"
        "[" -> "]"
        "{" -> "}"
        "<" -> ">"
      end)
      |> Enum.reduce(0, fn c, acc ->
        val =
          case c do
            ")" -> 1
            "]" -> 2
            "}" -> 3
            ">" -> 4
          end

        acc * 5 + val
      end)
    end)
    |> Enum.sort()
    |> then(fn vals ->
      idx = div(length(vals), 2)
      Enum.at(vals, idx)
    end)
  end

  def check_line(line) do
    Enum.reduce_while(line, [], fn c, acc ->
      if c in ~w|( [ { <| do
        {:cont, [c | acc]}
      else
        case c do
          ")" ->
            if hd(acc) == "(" do
              {:cont, tl(acc)}
            else
              {:halt, false}
            end

          "]" ->
            if hd(acc) == "[" do
              {:cont, tl(acc)}
            else
              {:halt, false}
            end

          "}" ->
            if hd(acc) == "{" do
              {:cont, tl(acc)}
            else
              {:halt, false}
            end

          ">" ->
            if hd(acc) == "<" do
              {:cont, tl(acc)}
            else
              {:halt, false}
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
end

Main.main() |> IO.puts()

# 288957 - input-small.txt answer
# 2858785164 - input-large.txt answer
