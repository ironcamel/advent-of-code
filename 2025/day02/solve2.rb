def match(n)
  s = n.to_s
  len = s.length
  (1..len/2).any? { |i| s.slice(0, i) * (len / i) == s }
end

ans = File.read('input-large.txt').split(',').flat_map do |s|
  r1, r2 = s.split '-'
  (r1.to_i..r2.to_i).filter { |n| match(n) }
end.sum
puts ans
