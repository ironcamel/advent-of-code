def main
  ranges = parse_input('input-large.txt')
  combine(ranges).map { |r| r.end - r.begin + 1 }.sum
end

def combine(ranges)
  overlaps = ranges.to_a.product(ranges.to_a).reject { |(x, y)| x == y }.filter { |(x, y)| x.overlap?(y) }
  if overlaps.empty?
    ranges
  else
    new_ranges = merge_overlaps(overlaps)
    old_ranges = overlaps.flat_map { |(r1, r2)| [r1, r2] }.to_set
    combine(ranges.difference(old_ranges).union(new_ranges))
  end
end

def merge_overlaps(overlaps)
  overlaps.map do |(r1, r2)|
    (x1, y1, x2, y2) = [r1.begin, r1.end, r2.begin, r2.end]
    if x1 < x2
      y1 < y2 ? x1..y2 : x1..y1
    else
      y1 < y2 ? x2..y2 : x2..y1
    end
  end.to_set
end

def parse_input(path)
  File.read(path).split("\n\n").first.split.map do |line|
    (x, y) = line.split '-'
    x.to_i..y.to_i
  end.to_set
end

p main

# 14 - input-small.txt answer
# 339668510830757 - input-large.txt answer
