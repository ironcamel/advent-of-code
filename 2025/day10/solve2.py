from z3 import *
import re

def main():
    with open('input-large.txt', 'r') as file:
        lines = file.readlines()
    pat = re.compile(r'\] (.+) \{(.+)\}')
    machines = []
    for line in lines:
        (buttons, values) = pat.search(line).groups()
        buttons = buttons.replace('(', '').replace(')', '').split()
        buttons = [ list(map(int, b.split(','))) for b in buttons ]
        values = list(map(int, values.split(',')))
        machines.append((buttons, values))

    print(sum([ solve_machine(m) for m in machines ]))

def solve_machine(machine):
    (buttons, values) = machine
    solver = Optimize()
    var_list = [ Int(f'a{i}') for i in range(len(buttons)) ]
    solver.minimize(Sum(var_list))
    for v in var_list: solver.add(v >= 0)

    for i, value in enumerate(values):
        vars2 = []
        for j, button in enumerate(buttons):
            if i in button:
                vars2.append(var_list[j])
        solver.add(Sum(vars2) == value)

    solver.check()
    m = solver.model()
    return m.eval(Sum(var_list)).as_long()

main()

# 33 - input-small.txt answer
# 20298 - input-large.txt answer
