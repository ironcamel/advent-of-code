@unit_circle = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def main
  grid = parse_input('input-large.txt')
  size = grid.size
  orig_size = size
  loop do
    grid = reduce_grid(grid)
    break if grid.size == size
    size = grid.size
  end
  orig_size - grid.size
end

def reduce_grid(grid) = grid.select { |p| not can_remove(p, grid) }.to_set

def can_remove(p, grid) = @unit_circle.count { |v| grid.member?(add_points(p, v)) } < 4

def add_points(p1, p2)
  i1, j1 = p1
  i2, j2 = p2
  [i1 + i2, j1 + j2]
end

def parse_input(path)
  File.readlines(path, chomp: 1).flat_map.with_index do |line, i|
    line.split(//).map.with_index do |c, j|
      [[i,j], c]
    end
  end.to_h.filter { |p, c| c == '@' }.map { |p, c| p }.to_set
end

p main
