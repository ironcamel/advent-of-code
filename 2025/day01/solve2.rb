cur, cnt = 50, 0
File.readlines('input-large.txt').map do |line|
  (_, dir, dist) = line.match(/(.)(.+)/).to_a
  dist = dist.to_i
  tmp = dir == "L" ? cur - dist : cur + dist
  inc = tmp == 0 || tmp < 0 && cur != 0 ? 1 : 0
  inc += tmp.abs / 100
  cnt += inc
  cur = tmp % 100
end
puts cnt
