defmodule Main do
  def main() do
    # "input-large.txt"
    #{modules, listeners} = "input-small.txt" |> parse_input()
    #{modules, listeners} = "input-small2.txt" |> parse_input()
    {modules, listeners} = "input-large.txt" |> parse_input()
    #dbg

    #modules = push_button(listeners) |> process(modules) |> dbg
    #push_button(listeners) |> process(modules)

    modules =
      #1..1
      1..1000
      |> Enum.reduce(modules, fn _i, acc ->
        #dbg
        {acc, signals} = push_button(acc, listeners)
        process(signals, acc)
      end)
    #(modules.low_cnt + 1000) * modules.high_cnt
    modules.low_cnt * modules.high_cnt
  end

  def handle_signal(modules, nil), do: {modules, nil}
  def handle_signal(modules, {val, from, "output"}) do
    p [handle_signal: val, from: from, to: "output"]
    {modules, nil}
  end

  def handle_signal(modules, {val, from, to}) do
    p [handle_signal: val, from: from, to: to]

    modules =
      if val == 1 do
        %{modules | high_cnt: modules.high_cnt + 1}
      else
        %{modules | low_cnt: modules.low_cnt + 1}
      end

    m = modules[to]
    #dbg
    case m && m.type do
      "%" ->
        if val == 1 do
          {modules, nil}
        else
          m = %{m | on: not m.on}
          modules = Map.put(modules, to, m)
          signal = if m.on, do: {1, to, m.to}, else: {0, to, m.to}
          #dbg
          {modules, signal}
        end
      "&" ->
        m = put_in m.memory[from], val
        modules = Map.put(modules, to, m)
        if m.memory |> Map.values |> Enum.all?(&(&1 == 1)) do
          signal = {0, to, m.to}
          {modules, signal}
        else
          signal = {1, to, m.to}
          {modules, signal}
        end
      _ -> {modules, nil}
    end
  end

  def process([], modules), do: modules

  def process([signal | signals], modules) do
    {modules, new_signal} = handle_signal(modules, signal)
    new_signals = split_signal(new_signal)
    process(signals ++ new_signals, modules)
  end

  def split_signal(nil), do: []
  def split_signal({val, from, targets}) do
    Enum.map(targets, fn to -> {val, from, to} end)
  end

  def push_button(modules, listeners) do
    modules = %{modules | low_cnt: modules.low_cnt + 1}
    {modules, listeners |> Enum.map(fn name -> {0, nil, name} end)}
  end

  def parse_input(path) do
    lines = path |> File.read!() |> String.split("\n", trim: true)

    modules =
      lines
      |> Enum.reject(fn line -> String.starts_with?(line, "broadcaster") end)
      |> Enum.map(fn line ->
        [_, type, name, to] = Regex.run(~r/(.)(.+) -> (.+)/, line)
        to = String.split(to, ", ")
        module = %{name: name, to: to, type: type, memory: %{}, on: false}
        {name, module}
      end)
      |> Map.new()

    modules =
      modules
      |> Enum.filter(fn {_name, m} -> m.type == "&" end)
      |> Enum.reduce(modules, fn {name, m}, acc ->
        memory =
          acc
          |> Enum.filter(fn {_i_name, i_m} -> name in i_m.to end)
          |> Enum.map(fn {i_name, _i_m} -> {i_name, 0} end)
          |> Map.new

        Map.put(acc, name, %{m | memory: memory})
      end)
      |> Map.merge(%{low_cnt: 0, high_cnt: 0})

    listeners =
      lines
      |> Enum.find(fn line -> String.starts_with?(line, "broadcaster") end)
      |> String.split(~r/.+ -> /)
      |> List.last
      |> String.split(", ")

    {modules, listeners}
  end

  def p(o, opts \\ []) do
    #IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
    o
  end
end

Main.main() |> IO.inspect()

# 743871576 - input-large.txt answer
