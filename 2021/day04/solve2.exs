defmodule Main do
  def main() do
    {nums, boards} = "input-large.txt" |> parse_input()
    draw_num(nums, boards)
  end

  def draw_num([num | nums], boards) do
    boards =
      boards
      |> Enum.map(fn board ->
        case board[num] do
          {i, j} ->
            board
            |> Map.put({:row_count, i}, board[{:row_count, i}] + 1)
            |> Map.put({:col_count, j}, board[{:col_count, j}] + 1)
            |> put_in([:picked, num], true)

          _ ->
            board
        end
      end)

    winner =
      Enum.find(boards, fn board ->
        Enum.any?(0..4, fn i -> board[{:row_count, i}] == 5 end) or
          Enum.any?(0..4, fn j -> board[{:col_count, j}] == 5 end)
      end)

    cond do
      winner && length(boards) == 1 ->
        all_sum =
          winner
          |> Enum.filter(fn
            {k, {_i, _j}} when is_integer(k) -> true
            _ -> false
          end)
          |> Enum.map(fn {k, _v} -> k end)
          |> Enum.sum()

        (all_sum - Enum.sum(Map.keys(winner.picked))) * num

      winner ->
        boards =
          Enum.reject(boards, fn board ->
            Enum.any?(0..4, fn i -> board[{:row_count, i}] == 5 end) or
              Enum.any?(0..4, fn j -> board[{:col_count, j}] == 5 end)
          end)
        draw_num(nums, boards)

      true ->
        draw_num(nums, boards)
    end
  end

  def parse_input(path) do
    [nums | boards] =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n")

    nums = nums |> String.split(",") |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn b ->
        b
        |> String.split("\n")
        |> Enum.with_index()
        |> Enum.map(fn {line, i} ->
          line
          |> String.trim()
          |> String.split(~r/\s+/)
          |> Enum.map(&String.to_integer/1)
          |> Enum.with_index()
          |> Enum.flat_map(fn {val, j} -> [{val, {i, j}}, {{:col_count, j}, 0}] end)
          |> Map.new()
          |> Map.put({:row_count, i}, 0)
        end)
        |> Enum.reduce(fn map, acc -> Map.merge(acc, map) end)
        |> Map.put(:picked, %{})
      end)

    {nums, boards}
  end
end

Main.main() |> IO.puts()

# 1924 - input-small.txt answer
# 31892 - input-large.txt answer
