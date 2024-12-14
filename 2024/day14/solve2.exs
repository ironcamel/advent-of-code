defmodule Main do
  @height 103
  @width 101

  def main() do
    grid = parse_input("input-large.txt")

    # find number of steps until there are 20 or more consecutive robots in a column
    Stream.map(1..10_000, fn n ->
      grid = move_robots(grid, n)

      found_col =
        Enum.any?(0..(@width - 1), fn j ->
          grid
          |> Map.keys()
          |> Enum.filter(fn {_i1, j1} -> j1 == j end)
          |> Enum.map(fn {i1, _j1} -> i1 end)
          |> Enum.sort()
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.chunk_by(fn [i1, i2] -> i2 - i1 end)
          |> Enum.any?(fn chunk -> length(chunk) >= 20 end)
        end)

      if found_col, do: {grid, n}, else: nil
    end)
    |> Enum.find(& &1)
    |> then(fn {grid, n} ->
      print(grid)
      IO.puts(n)
    end)
  end

  def print(grid) do
    for i <- 0..(@height - 1) do
      0..(@width - 1)
      |> Enum.map(fn j -> if grid[{i, j}], do: "#", else: " " end)
      |> Enum.join()
      |> IO.puts()
    end
  end

  def move_robots(grid, times) do
    grid
    |> Enum.flat_map(fn {{i, j}, robots} ->
      Enum.map(robots, fn {x, y} ->
        i2 = rem(i + y * times, @height)
        j2 = rem(j + x * times, @width)
        i2 = if i2 < 0, do: @height + i2, else: i2
        j2 = if j2 < 0, do: @width + j2, else: j2
        [j2, i2, x, y]
      end)
    end)
    |> build_grid()
  end

  def build_grid(data) do
    Enum.reduce(data, %{}, fn [j, i, x, y], acc ->
      robots = acc[{i, j}] || []
      Map.put(acc, {i, j}, [{x, y} | robots])
    end)
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ~r/p=(.+),(\S+) v=(.+),(.+)/ |> Regex.run(line) |> tl() |> Enum.map(&String.to_integer/1)
    end)
    |> build_grid()
  end
end

Main.main()

# 8270 - input-large.txt answer
# 
# #           #      #                      #                       #                          #
#                               #                   #                          #   #   #
#
#                                            ###############################
#                       #                    #                             #             #
#                                            #                             #
#                           #                #                             #
#         #                                  #                             #            #
#                                            #              #              #        #
#  #  #                     #                #             ###             #
#                                            #            #####            #              #
#                                            #           #######           #
#                     #                      #          #########          #
#          #                                 #            #####            #
#                                            #           #######           #
#                                            #          #########          #
#                   #                        #         ###########         #       #
#          #                                 #        #############        #                      #
#               #                            #          #########          #
#           #   #                            #         ###########         #
#                         #                  #        #############        #                       #
#                                            #       ###############       #
#                                            #      #################      #
#                                            #        #############        #
#          #                                 #       ###############       #
#                                            #      #################      #
#                        #        #          #     ###################     #
#                                            #    #####################    #
#    #                                       #             ###             #
#  #                     #                   #             ###             #                   #
#               #                            #             ###             #
#             #                              #                             #
#              #                           # #                             #
#                                            #                             #                #
#                                            #                             #
#                    #                       ###############################
#
#                                                              #
