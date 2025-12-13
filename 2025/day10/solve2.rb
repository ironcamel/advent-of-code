require 'z3'

def main
  parse_input('input-large.txt').map { |m| solve(m) }.sum
end

def solve(machine)
    (buttons, values) = machine
    solver = Z3::Optimize.new
    vars = buttons.map.with_index { |_, i| Z3.Int("a#{i}") }
    vars.each { |v| solver.assert v >= 0 }
    values.each.with_index do |n, i|
      vars2 = buttons.map.with_index
        .filter { |button, _j| button.include? i }
        .map { |_button, j| vars[j] }
      solver.assert Z3.Add(*vars2) == n
    end
    solver.minimize(Z3.Add(*vars))
    solver.satisfiable?
    solver.model.to_a.map { |k, v| v.to_i }.sum
end

def parse_input(path)
  File.readlines(path, chomp: 1).map do |line|
    (buttons, values) = line.match(/\] (.+) \{(.+)\}/).captures
    buttons = buttons.gsub('(', '').gsub(')', '').split().map { |s| s.split(',').map(&:to_i) }
    values = values.split(',').map(&:to_i)
    [buttons, values]
  end
end

p main

# 33 - input-small.txt answer
# 20298 - input-large.txt answer
