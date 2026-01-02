def main
  parse_input('input-large.txt').map do |bank|
    dig1 = bank[0..-2].max
    i = bank.find_index(dig1)
    dig2 = bank[i+1 .. -1].max
    (dig1 + dig2).to_i
  end.sum
end

def parse_input(path)
  File.readlines(path, chomp: 1).map { |line| line.split(//) }
end

p main
