def main
  grid = parse_input('input-large.txt')
  start = grid.filter { |p, val| val == "S" }.keys.first
  @cache = {}
  search(grid, start)
end

def search(graph, node)
  return @cache[node] if @cache[node]
  val = graph[node]
  (i, j) = node

  case val
  when "^"
    @cache[node] = search(graph, [i+1, j-1]) + search(graph, [i+1, j+1])
  when "S", "."
    @cache[node] = search(graph, [i+1, j])
  else
    @cache[node] = 1
  end
end

def parse_input(path)
  File.readlines(path, chomp: true).flat_map.with_index do |line, i|
    line.split(//).map.with_index do |c, j|
      [[i,j], c]
    end
  end.to_h
end

p main
