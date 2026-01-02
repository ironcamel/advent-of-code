def main
  parse_input('input-large.txt').map do |bank|
    digits = ""
    for i2 in -12..-1 do
      dig1 = bank[0..i2].max
      i = bank.find_index(dig1)
      bank = bank[i+1..]
      digits += dig1
    end
    digits.to_i
  end.sum
end

def parse_input(path)
  File.readlines(path, chomp: 1).map { |line| line.split(//) }
end

p main
