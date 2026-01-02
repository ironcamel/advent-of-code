def main
  #data = parse_input('input-large.txt')
  data = parse_input('input-small.txt')
end

def parse_input(path)
  File.readlines(path, chomp: 1).map do |line|
    line
  end
  File.readlines(path, chomp: 1).flat_map.with_index do |line, i|
    line.split(//).map.with_index do |c, j|
      [[i,j], c]
    end
  end.to_h
end

p main
