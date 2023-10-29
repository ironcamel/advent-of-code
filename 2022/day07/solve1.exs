defmodule Main do

  def go() do
    lines =
      # "input-small.txt"
      "input-large.txt"
      |> parse_input

    fs = do_cmds(lines)
    sum_dir(fs, ["/"]) |> elem(1)
  end

  def sum_dir(fs, path, acc \\ 0) do
    {dirs, files} =
      fs
      |> get_in(path)
      |> Enum.split_with(fn {_key, val} -> is_map(val) end)

    file_sum =
      files
      |> Enum.map(fn {_name, size} -> size end)
      |> Enum.sum()

    dir_data = Enum.map(dirs, fn {name, _dir} -> sum_dir(fs, path ++ [name], acc) end)
    dir_sum = dir_data |> Enum.map(&elem(&1, 0)) |> Enum.sum()
    acc_sum = dir_data |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    total = file_sum + dir_sum
    acc_sum = if total <= 100_000, do: acc_sum + total, else: acc_sum
    {total, acc_sum}
  end

  def do_cmds(lines, fs \\ %{"/" => %{}}, cwd \\ [])

  def do_cmds([], fs, _cwd), do: fs

  def do_cmds([line | lines], fs, cwd) do
    {lines, fs, cwd} = do_cmd(lines, line, fs, cwd)
    do_cmds(lines, fs, cwd)
  end

  def do_cmd(lines, "$ cd ..", fs, cwd) do
    {lines, fs, List.delete_at(cwd, -1)}
  end

  def do_cmd(lines, "$ cd " <> dir, fs, cwd) do
    {lines, fs, cwd ++ [dir]}
  end

  def do_cmd(lines, "$ ls", fs, cwd) do
    {items, lines} = Enum.split_while(lines, fn line -> not (line =~ ~r/\$/) end)
    fs = Enum.reduce(items, fs, fn item, acc ->
      case item do
        "dir " <> dir ->
          if get_in(acc, cwd ++ [dir]) do
            acc
          else
            put_in(acc, cwd ++ [dir], %{})
          end
        file ->
          [size, name] = String.split(file)
          put_in(acc, cwd ++ [name], String.to_integer(size))
      end
    end)
    {lines, fs, cwd}
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  def p(o) do
    IO.inspect(o, charlists: :as_lists)
  end

end

IO.inspect(Main.go())

# 95437 - input-small.txt answer
# 1084134 - input-large.txt answer
