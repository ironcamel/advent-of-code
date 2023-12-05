defmodule Main do

  def main() do
    #data = "input-small.txt" |> parse_input
    data = "input-large.txt" |> parse_input

    data.seeds
    |> Enum.map(fn seed ->
      find(seed, data, :seed_soil)
      |> find(data, :soil_fert)
      |> find(data, :fert_water)
      |> find(data, :water_light)
      |> find(data, :light_temp)
      |> find(data, :temp_humid)
      |> find(data, :humid_loc)
    end)
    |> Enum.min()
  end

  def find(x, data, key) do
    case data[key] |> Enum.find(fn {src_range, dest_range} -> x in src_range end) do
      nil -> x
      {src_range, dest_range} ->
        src_start.._last = src_range
        dest_start.._last = dest_range
        diff = x - src_start
        dest_start + diff
    end
  end

  def parse_input(path) do
    lines =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    seeds = lines |> hd |> String.split(": ") |> Enum.at(1) |> String.split() |> to_i

    %{
      seeds: seeds,
      seed_soil: gen_map(lines, "seed-to-soil"),
      soil_fert: gen_map(lines, "soil-to-fertilizer"),
      fert_water: gen_map(lines, "fertilizer-to-water"),
      water_light: gen_map(lines, "water-to-light"),
      light_temp: gen_map(lines, "light-to-temperature"),
      temp_humid: gen_map(lines, "temperature-to-humidity"),
      humid_loc: gen_map(lines, "humidity-to-location"),
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
      [dest, src, cnt] = String.split(line) |> to_i
      {src..src + cnt - 1, dest..dest + cnt - 1} 
    end)
  end

  def to_i(list) when is_list(list) , do: Enum.map(list, &String.to_integer/1)
  def to_i(s), do: String.to_integer(s)

  def p(o, opts \\ []) do
    IO.inspect(o, [charlists: :as_lists, limit: :infinity] ++ opts)
  end

end

#Main.main() |> IO.inspect()
Main.main() |> Main.p

# 26273516 - input-large.txt answer
