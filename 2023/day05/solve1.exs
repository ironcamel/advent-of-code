defmodule Main do

  def main(input_path) do
    data = parse_input(input_path)

    data.seeds
    |> Enum.map(fn seed ->
      seed
      |> get_dest(data, :seed_soil)
      |> get_dest(data, :soil_fert)
      |> get_dest(data, :fert_water)
      |> get_dest(data, :water_light)
      |> get_dest(data, :light_temp)
      |> get_dest(data, :temp_humid)
      |> get_dest(data, :humid_loc)
    end)
    |> Enum.min()
  end

  def get_dest(src, data, key) do
    case Enum.find(data[key], fn {src_range, _dest_range} -> src in src_range end) do
      nil -> src
      {src_start.._, dest_start.._} -> dest_start + (src - src_start)
    end
  end

  def parse_input(path) do
    lines =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    %{
      seeds: lines |> hd |> String.split(": ") |> Enum.at(1) |> String.split() |> to_i,
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
    lines
    |> Enum.split_while(fn line -> not String.starts_with?(line, name) end)
    |> then(fn {_, lines} -> lines end)
    |> tl()
    |> Enum.take_while(fn line -> line != "" end)
    |> Enum.map(fn line ->
      [dest, src, cnt] = String.split(line) |> to_i
      {src..src + cnt - 1, dest..dest + cnt - 1} 
    end)
  end

  def to_i(list), do: Enum.map(list, &String.to_integer/1)
end

"input-large.txt" |> Main.main() |> IO.puts()

# 35 - input-small.txt answer
# 26273516 - input-large.txt answer
