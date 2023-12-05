defmodule Main do

  def main() do
    #data = "foo.txt" |> parse_input
    #data = "input-small.txt" |> parse_input
    data = "input-large.txt" |> parse_input
    #data = Map.put(data, :seeds, [ 79..79, 14..14, 55..55, 13..13, ])

    new_loc_humid =
      data.loc_humid
      |> Enum.sort()
      |> Enum.reduce([], fn {r1, r2}, acc ->
        r1_start..r1_end = r1
        if length(acc) > 0 do
          {prev_start..prev_end, _} = List.last(acc)
          if r1_start - prev_end > 1 do
            new_r = prev_end+1..r1_start-1
            acc ++ [{new_r, new_r}, {r1, r2}]
          else
            acc ++ [{r1, r2}]
          end
        else
          acc ++ [{r1, r2}]
        end
      end)

    data = %{ data | loc_humid: new_loc_humid }

    p data
    try do
      find_min_loc(data)
      "not found"
    catch
      {loc, humid} -> [loc: loc, humid: humid]
    end

  end

  def find_min_loc(data) do
    data.loc_humid
    |> Enum.sort()
    |> Enum.each(fn {loc_range, humid_range} ->
      p checking_range: {loc_range, humid_range}
      found =
        Enum.zip(loc_range, humid_range)
        |> Enum.find(fn {_loc, humid} = zzz ->
          p checking_loc: zzz
          #dbg()
          find(humid, data, :humid_temp)
          |> find(data, :temp_light)
          |> find(data, :light_water)
          |> find(data, :water_fert)
          |> find(data, :fert_soil)
          |> find(data, :soil_seed)
          |> then(fn x -> Enum.find(data.seeds, fn range -> x in range end) end)
          #|> dbg
        end)

      if found do
        throw(found)
      end
    end)
  end

  def find_overlaps(data) do
    for pair1 <- data.loc_humid, pair2 <- data.loc_humid, pair1 != pair2 do
      {pair1, pair2}
    end
    |> Enum.filter(fn {{r1,_}, {r2,_}} -> not Range.disjoint?(r1, r2) end)
    |> Enum.map(fn pairs -> pairs |> Tuple.to_list |> Enum.sort end)
    |> Enum.uniq()
    |> Enum.map(fn pairs -> pairs |> List.to_tuple end)
  end

  def find(x, data, key) do
    case data[key] |> Enum.find(fn {src_range, dest_range} -> x in src_range end) do
      #nil -> if key == :soil_seed, do: nil, else: x
      nil -> x
      {src_range, dest_range} ->
        src_start.._last = src_range
        dest_start.._last = dest_range
        diff = x - src_start
        dest_start + diff
    end
  end

  #def find(x, data, key) do
  #  case data[key] |> Enum.find(fn {_src_range, dest_range} -> x in dest_range end) do
  #    nil -> if key == :soil_seed, do: nil, else: x
  #    {src_range, dest_range} ->
  #      src_start.._last = src_range
  #      dest_start.._last = dest_range
  #      diff = x - dest_start
  #      src_start + diff
  #  end
  #end

  def parse_input(path) do
    lines =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    seeds =
      lines
      |> hd
      |> String.split(": ")
      |> Enum.at(1)
      |> String.split()
      |> to_i
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, cnt] -> start..start + cnt - 1 end)

    %{
      seeds: seeds,
      soil_seed: gen_map(lines, "seed-to-soil"),
      fert_soil: gen_map(lines, "soil-to-fertilizer"),
      water_fert: gen_map(lines, "fertilizer-to-water"),
      light_water: gen_map(lines, "water-to-light"),
      temp_light: gen_map(lines, "light-to-temperature"),
      humid_temp: gen_map(lines, "temperature-to-humidity"),
      loc_humid: gen_map(lines, "humidity-to-location"),
    }
  end

  def gen_map(lines, name) do
    {_, lines} =
      lines
      |> Enum.split_while(fn line -> not String.starts_with?(line, name) end)

    lines
    |> tl
    |> Enum.take_while(fn line -> line != "" end)
    |> Enum.map(fn line ->
      [src, dest, cnt] = String.split(line) |> to_i
      {src..src + cnt - 1, dest..dest + cnt - 1} 
    end)
  end

  def to_i(list) when is_list(list) , do: Enum.map(list, &String.to_integer/1)
  def to_i(s), do: String.to_integer(s)

  def p(o, opts \\ []) do
    o
    #IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

Main.main() |> IO.inspect()
#Main.main() |> Main.p

# {67, 63}
