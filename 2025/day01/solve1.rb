cur, cnt = 50, 0
File.readlines('input-large.txt').map do |line|
  (_, dir, val) = line.match(/(.)(.+)/).to_a
  val = val.to_i
  cur = dir == "L" ? (cur - val) % 100 : cur = (cur + val) % 100
  cnt += 1 if cur == 0
end
puts cnt
