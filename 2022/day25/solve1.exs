defmodule Main do
  def go() do
    "input-large.txt"
    #"input-small.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&to_i(&1))
    |> Enum.sum()
    |> to_s
  end

  def to_i(s) when is_binary(s) do
    String.codepoints(s)
    |> Enum.map(fn x ->
      case x do
        "=" -> -2
        "-" -> -1
        _ -> String.to_integer(x)
      end
    end)
    |> Enum.reverse()
    |> to_i
  end

  def to_i(digits, sum \\ 0, power \\ 0)
  def to_i([], sum, _), do: sum
  def to_i([x | tail], sum, power), do: to_i(tail, sum + x * 5 ** power, power + 1)

  def max_for_pow(pow) when pow < 0, do: 0
  def max_for_pow(pow), do: div(5 ** (pow + 1), 2)

  def start_pow(x, pow \\ 0) do
    if x <= max_for_pow(pow), do: pow, else: start_pow(x, pow + 1)
  end

  def to_s(i), do: to_s(i, "", start_pow(i))
  def to_s(_, s, -1), do: s

  def to_s(i, s, pow) do
    x = max_for_pow(pow - 1)

    cond do
      i - 2 * 5 ** pow + x >= 0 -> to_s(i - 2 * 5 ** pow, s <> "2", pow - 1)
      i - 5 ** pow + x >= 0 -> to_s(i - 5 ** pow, s <> "1", pow - 1)
      i + x >= 0 -> to_s(i, s <> "0", pow - 1)
      i + 5 ** pow + x >= 0 -> to_s(i + 5 ** pow, s <> "-", pow - 1)
      i + 2 * 5 ** pow + x >= 0 -> to_s(i + 2 * 5 ** pow, s <> "=", pow - 1)
    end
  end

  # def p(o) do #IO.inspect(o) end
end

IO.puts(Main.go())

# 2=-1=0 - input-small.txt answer
# 122-2=200-0111--=200 - input-large.txt answer
#
