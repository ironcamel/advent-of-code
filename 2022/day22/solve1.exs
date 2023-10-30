defmodule Main do
  def go() do
    {board, moves} = "input-large.txt" |> parse_input
    walk(moves, board) |> calc()
  end

  def calc({tile, facing}) do
    val =
      case facing do
        :e -> 0
        :s -> 1
        :w -> 2
        :n -> 3
      end

    1000 * tile.i + 4 * tile.j + val
  end

  def walk(moves, board) do
    init_j = board[1] |> Enum.map(fn {j, _val} -> j end) |> Enum.min()
    init_tile = board[1][init_j]
    walk(moves, board, init_tile, :e)
  end

  def walk([], _board, tile, facing) do
    {tile, facing}
  end

  def walk([move | moves], board, tile, facing) do
    {tile, facing} = step(move, board, tile, facing)
    walk(moves, board, tile, facing)
  end

  def step(0, _board, tile, facing) do
    {tile, facing}
  end

  def step(cnt, board, tile, facing) when is_integer(cnt) do
    if tile[facing] do
      next_tile = get_in(board, tile[facing])
      step(cnt - 1, board, next_tile, facing)
    else
      {tile, facing}
    end
  end

  def step(turn, _board, tile, facing) do
    %{
      "R" => %{e: :s, w: :n, n: :e, s: :w},
      "L" => %{e: :n, w: :s, n: :w, s: :e}
    }
    |> get_in([turn, facing])
    |> then(fn new_facing -> {tile, new_facing} end)
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

    board =
      Enum.reduce(board, board, fn {i, row}, acc ->
        Enum.reduce(row, acc, fn {j, val}, acc2 ->
          put_in(acc2, [i, j], gen_tile(board, i, j, val))
        end)
      end)
      |> add_horizontal_wraps()
      |> add_vertical_wraps()

    {board, moves}
  end

  def add_vertical_wraps(board) do
    max_j =
      for {_i, row} <- board do
        for {j, _val} <- row do
          j
        end
        |> Enum.max()
      end
      |> Enum.max()

    Enum.reduce(1..max_j, board, fn j, acc ->
      rows = board |> Enum.filter(fn {i, _row} -> board[i][j] != nil end)
      min_i = rows |> Enum.map(fn {i, _row} -> i end) |> Enum.min()
      max_i = rows |> Enum.map(fn {i, _row} -> i end) |> Enum.max()

      if board[min_i][j] && board[max_i][j] do
        key1 = [min_i, j]
        key2 = [max_i, j]
        tile1 = get_in(acc, key1) |> Map.put(:n, key2)
        tile2 = get_in(acc, key2) |> Map.put(:s, key1)
        acc |> put_in(key1, tile1) |> put_in(key2, tile2)
      else
        acc
      end
    end)
  end

  def add_horizontal_wraps(board) do
    Enum.reduce(board, board, fn {i, row}, acc ->
      min_j = row |> Map.keys() |> Enum.min()
      max_j = row |> Map.keys() |> Enum.max()

      if board[i][min_j] && board[i][max_j] do
        key1 = [i, min_j]
        key2 = [i, max_j]
        tile1 = get_in(acc, key1) |> Map.put(:w, key2)
        tile2 = get_in(acc, key2) |> Map.put(:e, key1)
        acc |> put_in(key1, tile1) |> put_in(key2, tile2)
      else
        acc
      end
    end)
  end

  def gen_tile(_board, _i, _j, val) when val in [nil, false], do: false

  def gen_tile(board, i, j, _) do
    val = fn i, j -> if board[i][j], do: [i, j], else: board[i][j] end
    %{e: val.(i, j + 1), w: val.(i, j - 1), n: val.(i - 1, j), s: val.(i + 1, j), i: i, j: j}
  end

  def p(o, _opts \\ []) do
    # IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
    o
  end
end

IO.puts(Main.go())

# 6032 - input-small.txt answer
# 36518 - input-large.txt answer
