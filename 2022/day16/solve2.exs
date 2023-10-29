defmodule Main do
  def go() do
    data =
      "input-small.txt"
      #"input-large.txt"
      |> parse_input

    distances = calc_distances(data)

    history =
      data
      |> prune_zero_valves()
      |> search(distances)
      |> List.flatten
      |> Enum.map(fn {p, set} -> {p, MapSet.delete(set, "AA")} end)

    #history = [
    #  {1333, MapSet.new(["BB", "DD", "EE"])},
    #  {1345, MapSet.new(["BB", "CC", "DD", "EE", "HH", "JJ"])},
    #  {567, MapSet.new(["JJ"])},
    #  {967, MapSet.new(["JJ"])},
    #  {985, MapSet.new(["HH", "JJ"])},
    #  {1030, MapSet.new(["EE", "HH", "JJ"])},
    #]

    map =
      Enum.reduce(history, %{}, fn {p, set}, acc ->
        old = Map.get(acc, set, 0)
        if p > old, do: Map.put(acc, set, p), else: acc
      end)

    (for {set1, p1} <- map, {set2, p2} <- map, do: {set1, set2, p1 + p2})
    |> Enum.filter(fn { set1, set2, _val} -> MapSet.disjoint?(set1, set2) end)
    |> Enum.max_by(fn { _set1, _set2, val} -> val end)
    |> elem(2)

  end

  def search(
        valves,
        distances,
        cur \\ "AA",
        time_left \\ 26,
        pressure \\ 0,
        ignore \\ MapSet.new(["AA"]),
        history \\ []
      )

  def search(valves, distances, cur, time_left, pressure, ignore, history) do
    candidates = Map.keys(valves) |> Enum.filter(fn id -> not MapSet.member?(ignore, id) end)
    # p [cur, pressure, ignore, time_left]
    if length(candidates) > 0 do
      candidates
      |> Enum.map(fn next_valve ->
        time_left = time_left - distances[cur][next_valve] - 1

        if time_left >= 0 do
          pressure = pressure + time_left * valves[next_valve].rate
          ignore = MapSet.put(ignore, next_valve)
          history = history ++ [{pressure, ignore}]
          search(valves, distances, next_valve, time_left, pressure, ignore, history)
        else
          history
        end
      end)
    else
      history
    end
  end

  def prune_zero_valves(data) do
    Enum.filter(data, fn {k, v} -> k == "AA" or v.rate > 0 end)
    |> Enum.into(%{})
  end

  # Floyd–Warshall algorithm
  def calc_distances(data) do
    ids = Map.keys(data)

    distances =
      for(x <- ids, y <- ids, do: {x, y})
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        init_dist =
          cond do
            x == y -> 0
            MapSet.member?(data[x].valves, y) -> 1
            true -> 10 ** 9
          end

        put_in(acc[x], acc[x] || %{})
        |> put_in([x, y], init_dist)
      end)

    for(k <- ids, i <- ids, j <- ids, do: {k, i, j})
    |> Enum.reduce(distances, fn {k, i, j}, acc ->
      put_in(acc[i][j], Enum.min([acc[i][j], acc[i][k] + acc[k][j]]))
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line(&1))
    |> Enum.reduce(%{}, fn [id, rate, valves], acc ->
      node = %{id: id, rate: rate, valves: MapSet.new(valves)}
      Map.put(acc, id, node)
    end)
  end

  def parse_line(line) do
    [_, id, rate, valves] = Regex.run(~r/Valve (\w+) .*rate=(\d+);.*valve.? (.+)/, line)
    [id, String.to_integer(rate), String.split(valves, ", ")]
  end

  def p(o) do
    IO.inspect(o, charlists: :as_lists, limit: :infinity)
  end
end

Main.p(Main.go())

# 1707 - input-small.txt answer
# 1999 - input-large.txt answer
# time elixir solve2.exs
# 1999
# elixir solve2.exs  16.53s user 4.04s system 98% cpu 20.798 total
