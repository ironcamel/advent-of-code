@unit_circle = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def main
  grid = parse_input('input-large.txt')
  grid.count { |p| can_remove(grid, p) }
end

def can_remove(grid, p) = @unit_circle.count { |v| grid.member?(add_points(p, v)) } < 4

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
