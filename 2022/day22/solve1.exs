defmodule Main do
  def go() do
    # "input-large.txt"
    lines = "input-small.txt" |> parse_input
  end

  def parse_input(path) do
    {movesLine, boardLines} =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> List.pop_at(-1)

    moves =
      Regex.split(~r/(\d+)/, movesLine, include_captures: true, trim: true)
      |> Enum.map(fn x -> if x =~ ~r/\d/, do: String.to_integer(x), else: x end)

    # put_tile = fn
    put_tile = fn board, i, j, c ->
      val =
        case c do
          "." -> true
          "#" -> false
        end

      put_in(board, [Access.key(i, %{}), j], val)
    end

    put_tiles = fn tiles, board ->
      # IO.inspect tiles
      Enum.reduce(tiles, board, fn {i, j, c}, acc ->
        put_tile.(acc, i, j, c)
      end)
    end

    board =
      boardLines
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {line, i}, acc ->
        line
        |> String.codepoints()
        |> Enum.with_index(1)
        |> Enum.filter(fn {c, _j} -> c != " " end)
        |> Enum.map(fn {c, j} -> {i, j, c} end)
        |> put_tiles.(acc)
      end)
  end

  def p(o) do
    IO.inspect(o, charlists: :as_lists)
  end
end

IO.inspect(Main.go())
