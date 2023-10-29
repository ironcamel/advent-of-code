defmodule Main do
  def go() do
    data =
      # "input-small.txt"
      "input-large.txt"
      |> parse_input

    distances = calc_distances(data)

    prune_zero_valves(data)
    |> search(distances)
  end

  def search(
        valves,
        distances,
        cur \\ "AA",
        time_left \\ 30,
        pressure \\ 0,
        ignore \\ MapSet.new(["AA"])
      )

  def search(valves, distances, cur, time_left, pressure, ignore) do
    candidates = Map.keys(valves) |> Enum.filter(fn id -> not MapSet.member?(ignore, id) end)
    # p [cur, pressure, ignore, time_left]
    if length(candidates) > 0 do
      candidates
      |> Enum.map(fn next_valve ->
        time_left = time_left - distances[cur][next_valve] - 1

        if time_left >= 0 do
          pressure = pressure + time_left * valves[next_valve].rate
          ignore = MapSet.put(ignore, next_valve)
          search(valves, distances, next_valve, time_left, pressure, ignore)
        else
          pressure
        end
      end)
      |> Enum.max(fn -> 0 end)
    else
      pressure
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
    IO.inspect(o, charlists: :as_lists)
  end
end

Main.p(Main.go())

# 1651 - input-small.txt answer
# 1796 - input-large.txt answer
